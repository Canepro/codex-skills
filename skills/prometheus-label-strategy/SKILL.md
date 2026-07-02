---
name: prometheus-label-strategy
license: Apache-2.0
description: Design and audit Prometheus label schemas to prevent high cardinality at the source. Covers instrumentation hygiene, target vs application labels, histogram label discipline, info metrics, and exemplars. Use when designing or reviewing metric labels or asked how to stop cardinality growth before ingest. For a live cardinality fire, use prometheus-cardinality-troubleshooter.
---

# Prometheus Label Strategy Evaluator

This skill evaluates, audits, designs, and improves Prometheus label schemas, and answers how to prevent high cardinality at the source. Use this guide to give structured, specific advice.

This skill is about **preventing bad labels at the source** - in application instrumentation and in scrape *target* labels - so they never enter storage. It is **not** about stripping labels off metrics after they've been emitted: removing a label that makes a series unique at scrape time silently breaks the data (see [The One Rule](#the-one-rule-never-drop-a-label-that-makes-a-series-unique) below). For reducing the cost of series that already exist in Grafana Cloud, use a dedicated `adaptive-metrics` skill only when installed; otherwise use `prometheus-grafana-triage` and keep the Adaptive Metrics recommendation explicit. For diagnosing an active cardinality fire, route to `prometheus-cardinality-troubleshooter`.

---

## The One Rule: Never Drop a Label That Makes a Series Unique

**You cannot remove, at scrape time, any label that makes a series unique.** Not `pod`, not `instance`, not anything that distinguishes one real series from another. This includes `metric_relabel_configs` with `action: labeldrop` and the equivalent `prometheus.relabel` rules in Alloy.

It looks like a cardinality win. It is not - it **breaks the data**, silently and permanently:

- **Counter resets get mixed together.** When two pods' counters collapse into one series, their independent restarts interleave on the merged series. `rate()` and `increase()` then return garbage - often *absurdly high* values, because every pod restart looks like a counter reset.
- **DPM inflates instead of dropping.** Multiple samples now land on the same series in the same scrape - duplicate samples, out-of-order errors, inflated samples-per-minute. People come back weeks later asking "why is my DPM so high?" or "why is `rate()` returning absurd numbers?" - and there is **no evidence left in the data** of where it broke.
- **The aggregation is wrong, not just coarse.** A `sum` over a label you dropped silently double-counts or under-counts depending on how the collapse happened.

The trap is that none of this errors at config time. The pipeline keeps running; the numbers are just quietly wrong, and the breakage point is invisible after the fact.

**The right tools, in order:**

1. **Don't emit the bad label in the first place** - fix the application code. This is the only place a label can be *removed* without consequence, because the series was never unique on it to begin with.
2. **For series already flowing into Grafana Cloud that you can't fix at the source, use Adaptive Metrics** (post-ingest, counter-reset-aware, auditable, reversible). Route the user to the `adaptive-metrics` skill only when it is installed; otherwise use `prometheus-grafana-triage` for Grafana Cloud investigation and document the Adaptive Metrics rule intent. This routing statement is canonical; later sections just point here.

`metric_relabel_configs` has a couple of narrow, safe uses (dropping an *entire* unwanted metric; removing a label that *exactly duplicates* a target label) - covered in [Source-Side Prevention](#4-metric_relabel_configs-narrow-safe-uses-only) - but **reducing cardinality by dropping a distinguishing label is never one of them.**

---

## Core Concepts

**Series** are the fundamental unit in Prometheus. Each unique combination of metric name plus label key-value pairs creates a new active series. Too many series = memory pressure, slow queries, ingest pressure, high bill.

**Cardinality** = the number of unique values a label can have. Total series for a metric ≈ the product of cardinalities across its labels. A metric with `path` (100 values), `status_code` (10 values), `method` (5 values), and `instance` (50 values) = **250,000 series per metric**. Adding one more high-cardinality label often 10-100×s the count.

**The dual impact rule**: High-cardinality labels hurt on both paths:
- **Ingestion path**: More active series → larger head block, larger WAL, more memory, larger remote_write payloads, higher Grafana Cloud bill (Active Series + DPM)
- **Query path**: PromQL operators (`sum by`, `rate`, joins) must materialize matching series in memory. High cardinality balloons query memory and latency

**Series churn** is the silent killer. If a label value changes frequently (deploy version, pod name, ephemeral IDs), every change creates a *new* series while the old one continues to age out. Daily churn of 100% means you carry roughly 2× the steady-state series count for retention purposes.

**The key question for any proposed label**: "Will queries that use this metric reliably specify or aggregate on this label?" If no → it should NOT be a label.

---

## Label Evaluation Framework

When auditing a label set, assess each label against these criteria.

### Cardinality Scoring

| Label Example | Cardinality | Verdict |
|---|---|---|
| `env` (prod/staging/dev) | 2-5 values | ✅ Good |
| `job` (Prometheus scrape job) | 5-50 values | ✅ Good |
| `cluster`, `region` | Tens | ✅ Good |
| `namespace` (K8s) | Tens-low hundreds | ✅ Acceptable |
| `service`, `workload`, `container` | Tens-hundreds | ✅ Acceptable |
| `instance` (host:port) | Hundreds-low thousands | ⚠️ Evaluate - fine on per-instance metrics, risky on aggregated ones |
| `pod` (K8s) | Thousands + transient = high churn | ⚠️ Required for K8s monitoring and series uniqueness - keep it. If `pod`-level series are too expensive, reduce them post-ingest with Adaptive Metrics; **never** remove the label at scrape |
| `path` / `route` (HTTP) | Bounded if templated; unbounded if raw URLs | ⚠️ Only with templated values (`/users/:id`) |
| `version`, `image_tag`, `git_sha` | Grows on every deploy → churn | ⚠️ Use sparingly; consider info-metric pattern |
| `user_id`, `request_id`, `trace_id` | Unbounded | ❌ Never as label - use exemplars |
| `customer_id`, `tenant_id` | Often unbounded | ❌ Only acceptable for small fixed tenant counts |
| `error_message`, `query`, `sql` | Unbounded text | ❌ Never |

### Access Pattern Alignment

For each label, ask:
- Do queries on this metric reliably aggregate by or filter on this label?
- Does this label logically segment the metric the way users think about it?
- Would removing this label force users to use exemplars, logs, or traces instead - and would that be acceptable for the rare lookup case?

### Static vs. Dynamic Label Values

- **Static / target labels** (set once per scrape target via `relabel_configs`, e.g., `env=prod`, `cluster=us-east`, `team=payments`) add cardinality proportional to *targets*, not requests. Cheap and high-value. Use freely.
- **Dynamic / sample labels** (emitted by the application per measurement, e.g., `status_code`, `method`, `cache_hit`) multiply cardinality by *value count*. Keep possible values in the single digits or low tens. **The application code is the source of truth - fix it there, not in Prometheus.**

### Consistency Check

- Label *names* consistent across services? (`status` vs `status_code` vs `http_status` produces three separate label families - joins break)
- Label *values* normalized? (`200` vs `"200"`, `GET` vs `get`, `Error` vs `error`)
- Naming convention consistent? Prometheus convention is `snake_case` for both metric and label names
- Same concept, same name across services? (`service` vs `svc` vs `app_name`)

### Histogram Bucket Discipline (critical, often missed)

Every histogram metric multiplies its base cardinality by **(bucket count + 3)** - buckets via `_bucket{le="..."}` plus `_sum`, `_count`, and `_created` (Prometheus 2.39+).

- Default `prometheus.DefBuckets` has 11 buckets → **14× multiplier**
- A histogram with `method`, `path`, `status` already at 1,000 series becomes **14,000 series** after adding histogram cardinality
- **Always trim histogram label cardinality first** - labels matter 14× more on histograms than on counters/gauges
- Consider native histograms (Prometheus 2.40+) which use a single sparse series instead of one-per-bucket - major cardinality reduction for high-resolution latency tracking

### Info-Metric Pattern (for high-churn metadata)

When you want to *know* about a label (e.g., `version`, `git_sha`, `image_tag`) without paying for it on every metric, use an info metric:

```
# A single low-cardinality counter/gauge of value 1, with the metadata attached
app_build_info{app="payment-api", version="2.4.1", git_sha="a1b2c3"} 1
```

Then join at query time:
```promql
sum by (version) (
  rate(http_requests_total{app="payment-api"}[5m])
  * on (app) group_left (version) app_build_info
)
```

The `version` label lives on exactly one series per build, not on every metric.

---

## Evaluation Output Format

When auditing a label set, produce a report in this structure:

```
## Prometheus Label Strategy Audit

### Summary
[1-2 sentence overall assessment, total estimated active series, biggest risks]

### Per-Label Analysis
| Metric Family | Label | Cardinality | Used in Queries? | Verdict | Action |
|---|---|---|---|---|---|
| http_requests_total | path | Unbounded (raw URLs) | Sometimes | ❌ Remove | Template in code: `/users/:id` not `/users/12345` |
| http_requests_total | pod | High + churn | Rarely | ⚠️ Keep, makes the series unique | If too expensive, aggregate away with Adaptive Metrics; query by `workload` for the common case |

### Histogram-Specific Findings
[Highlight any histograms with high label cardinality, these are 14×+ amplified]

### Estimated Impact
- Active series reduction: [X series → Y series]
- DPM reduction: [X DPM → Y DPM]  (samples-per-minute = series × ~6 at 10s scrape)
- Memory impact: [if measurable]

### Recommended Label Set
[Final recommended labels per metric family]

### Implementation Plan
1. [Code changes, instrumentation hygiene: stop emitting bad labels at the source]
2. [Scrape target labels, relabel_configs (additive: env, cluster, team, workload)]
3. [Post-ingest cost reduction on series you can't fix at the source, Adaptive Metrics]
4. [Recording rules to materialize useful aggregates]
```

---

## Recommended Common Target Labels

These should be set as **target labels** (via `relabel_configs` on the scrape job, NOT emitted by the app) - they're per-target, low cardinality, high query value:

| Label | Purpose | Notes |
|---|---|---|
| `job` | Prometheus scrape job name | Set automatically by Prometheus |
| `instance` | Target endpoint (`host:port`) | Set automatically; rename via `relabel_configs` to a friendlier value if needed |
| `env` | Environment (`prod`, `staging`, `dev`) | Set via static_configs labels or service discovery |
| `cluster` | Multi-cluster differentiation | Critical for federation/Mimir multi-tenant |
| `region` | Geographic region | |
| `team` / `squad` | Ownership - also useful for access control | |
| `service` | Logical service identity | One service may span multiple jobs |

These should **NOT** be re-emitted by the application. If the app emits a `cluster` label, it duplicates the target label and creates collisions / `honor_labels` decisions you don't want to make.

---

## Kubernetes Patterns

### Recommended Labels (from kubernetes_sd_configs)

| Label | Source | Notes |
|---|---|---|
| `namespace` | Pod metadata | Always keep |
| `container` | Pod spec | Low cardinality, useful for multi-container pods |
| `workload` | Derived: `{controller_kind}/{controller_name}` | Add as a stable aggregation key *alongside* `pod` - static, predictable. It's an addition, not a replacement: don't use it as an excuse to drop `pod` |
| `service` | K8s Service | If scraping via Service |

### Handling the `pod` Label

`pod` is high-cardinality and transient - it rolls on every deploy and restart, so it dominates churn and series count. But it is also a label that **makes K8s series unique**, and Kubernetes monitoring (per-pod resource attribution, kube-state-metrics joins) depends on it. [The One Rule](#the-one-rule-never-drop-a-label-that-makes-a-series-unique) applies: **do not drop `pod` at scrape time.** Collapsing pods into one series mixes their counter resets and breaks `rate()`.

Instead:
- **Add `workload`** (`{controller_kind}/{controller_name}`) as a *target* label via `relabel_configs`, so dashboards and alerts can aggregate on the stable workload identity (`sum by (workload)`) without touching `pod`. This is additive - it removes nothing.
- **Don't emit `pod` from application code** - let it come from Kubernetes service discovery, so there is exactly one source of truth (see below).
- **If `pod`-level series are genuinely too expensive in Grafana Cloud**, do not drop `pod` at scrape time; reduce them post-ingest with Adaptive Metrics (see [lever 3](#3-adaptive-metrics-grafana-cloud--post-ingest-the-safe-way-to-reduce-cardinality)).

### Don't Map Ephemeral Fields into Labels in the First Place

`uid` regenerates on every pod recreation and has no legitimate query use. The fix is to **never map it into a label** - leave it out of your `relabel_configs`. (It isn't in default `kubernetes_sd_configs` output unless you explicitly target it.) Don't try to `labeldrop` it after the fact - by then it's already distinguishing series, and removing it breaks the data exactly like dropping any other unique label.

### One Source of Truth for Target Identity

`instance`, `pod`, `node`, and `host` should come from **scrape target labels**, not from application code. If the app *also* emits its own `instance`/`node`, you get duplicates and `honor_labels` collisions. The fix is **in the application** - stop emitting them - not a scrape-time `labeldrop`. (Removing a label that *exactly duplicates* a target label is the one narrow exception; see [metric_relabel_configs](#4-metric_relabel_configs-narrow-safe-uses-only).)

### kube-state-metrics label propagation ⚠️
- `kube_pod_labels{label_app_kubernetes_io_*=...}` can carry dozens of metadata labels
- Each unique pod label combination is a new series
- Restrict at the source with kube-state-metrics' `--metric-labels-allowlist` - this controls what is *ever emitted*, so it's prevention, not destructive after-the-fact dropping

---

## Source-Side Prevention: Where to Fix What

There are five levers, in **order of preference**:

### 1. Fix in the Application (best)

Bad labels emitted by the app are the root cause. Examples:
- HTTP paths: use templated routes (`/users/:id`) not raw paths
- Error metrics: use a small enum (`error_type="timeout"`) not the error message string
- User-scoped metrics: don't include `user_id` - use exemplars to point to logs/traces
- Free-form input: never emit user-supplied strings as label values

If you control the code, this is always the right fix. It saves cost on every downstream system (Prometheus, remote_write, Mimir, Grafana Cloud).

### 2. `relabel_configs` (target-time relabeling)

Runs *before* the scrape. Used to:
- Set target labels (`env`, `cluster`, `team`) on discovered targets
- Drop entire targets you don't want to scrape
- Rewrite `instance` to a friendly value
- Add identity from service discovery metadata

```yaml
scrape_configs:
  - job_name: my-app
    kubernetes_sd_configs:
      - role: pod
    relabel_configs:
      # Set workload from controller metadata
      - source_labels: [__meta_kubernetes_pod_controller_kind, __meta_kubernetes_pod_controller_name]
        target_label: workload
        separator: /
      # Set env from a pod label
      - source_labels: [__meta_kubernetes_pod_label_env]
        target_label: env
      # Only scrape pods explicitly opted in
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
        regex: "true"
        action: keep
```

### 3. Adaptive Metrics (Grafana Cloud - post-ingest, the safe way to reduce cardinality)

When the cardinality is structural and you *can't* fix it at the source - the label legitimately exists and makes series unique, you just don't need every value at full resolution - **Adaptive Metrics is the correct tool, and the only safe way to reduce the cost of series that already exist.**

It works *after* ingest, as aggregation rules applied in Grafana Cloud. Crucially, it aggregates series **correctly**:
- It handles counter resets properly, so `rate()` and `increase()` stay accurate.
- It records what was aggregated, so there's an audit trail - you can answer "why did this change?" later.
- It's reversible: drop a rule and the full-resolution series come back.

This is the difference between "the data is now cheaper" with Adaptive Metrics and "the data is now wrong" with scrape-time label-removal. Routing for rule design follows [The One Rule](#the-one-rule-never-drop-a-label-that-makes-a-series-unique) tool list.

### 4. `metric_relabel_configs` (narrow, safe uses only)

Runs *after* the scrape, *before* storage.

> ⚠️ **Do not use `metric_relabel_configs` (or Alloy `prometheus.relabel`) to drop a label that distinguishes series**; see [The One Rule](#the-one-rule-never-drop-a-label-that-makes-a-series-unique). Use lever 1 (application code) or lever 3 (Adaptive Metrics) instead. The same caution applies to *normalizing* a label value (e.g. collapsing `status_code` to `2xx`) at scrape: it merges distinct series and produces duplicate-sample errors; do that in code or via Adaptive Metrics, never here.

The genuinely safe uses are:

- **Drop an entire metric you never want stored** - you're discarding the whole metric, not collapsing distinct series into one:
  ```yaml
  metric_relabel_configs:
    - source_labels: [__name__]
      regex: my_app_request_details
      action: drop
  ```
- **Remove a label that *exactly duplicates* a target label.** If the app emits its own `cluster`/`instance` that already comes from the scrape target, the target label still provides uniqueness, so removing the duplicate breaks nothing. Prefer fixing the app, but this is a safe stopgap.

That's the whole list. If you're reaching for `metric_relabel_configs` to bring down a series count, you almost certainly want Adaptive Metrics instead.

### 5. Recording Rules (query-time cardinality reduction)

Pre-aggregate expensive series into a lower-cardinality recorded series. Stored at the same data point density but with far fewer series.

```yaml
groups:
  - name: http-requests-aggregates
    interval: 30s
    rules:
      # Drop pod/instance dimension; keep only service-level rollup
      - record: service:http_requests:rate5m
        expr: sum by (service, env, cluster, status_code) (rate(http_requests_total[5m]))
```

Queries that target the rollup are dramatically cheaper. The raw series still exist - recording rules reduce query cost, not ingest cost (lever 3 handles that).

---

## Instrumentation Hygiene (for app developers)

If the user is *writing* instrumentation code, these are the rules:

| Rule | Why |
|---|---|
| Never use unbounded user input as a label value | `email`, `user_id`, `query string`, `error message` - they're the #1 cardinality bug |
| Template HTTP paths before recording | `/users/{id}` not `/users/12345`. Most frameworks do this via routing metadata |
| Bound error labels via small enums | `error_type="timeout"` not `error="connection to db-shard-7 timed out at 14:32:09"` |
| Don't put `version` / `git_sha` / `build_id` on every metric | Use an info metric and join at query time |
| Don't emit `pod` / `node` / `host` from code | Comes from scrape targets - duplicating creates collisions |
| Avoid dynamically constructed label *names* (keys) | `metric{[user]=1}` cannot be bounded - use a fixed key |
| Use histograms sparingly and trim labels first | 14× cardinality amplification |
| Prefer exemplars over labels for trace correlation | Exemplars carry `trace_id` without inflating cardinality |

### Exemplars (the escape hatch)

Exemplars attach a `trace_id` (or any key-value pair) to specific samples *without* making it a label dimension. The ideal home for high-cardinality correlation data.

Requires OpenMetrics format, Prometheus 2.26+, scrape config:
```yaml
scrape_configs:
  - job_name: my-app
    enable_protobuf_negotiation: true
    # Or for text-format:
    follow_redirects: true
```

And on the Prometheus server:
```yaml
storage:
  exemplars:
    max_exemplars: 100000
```

Use exemplars for:
- `trace_id` correlation (Tempo, Jaeger)
- `request_id` for specific debug lookups
- Any sparse "useful when you need it" key

Query exemplars via Grafana's exemplars-on-graph feature, not via PromQL aggregation.

---

## The 80/20 Rule

The most impactful improvements almost always come from these five changes:

1. **Drop unbounded labels at the app layer** - `path` (untemplated), `user_id`, `error_message`. Single biggest win.
2. **Trim histogram label cardinality before anything else** - 14× amplification on every histogram.
3. **Don't emit `pod`/`instance`/`node` from application code** - let them come from scrape targets, and add a stable `workload` target label to aggregate on.
4. **Use info metrics for `version` / `git_sha` / `image_tag`** - eliminates deploy-driven churn.
5. **Set target labels via `relabel_configs`, not app code** - `env`, `cluster`, `team`, `service` should never be emitted by the application.

Focus on these before anything else.

---

## Labels to Avoid - Quick Reference

| Label | Why | Alternative |
|---|---|---|
| `user_id`, `customer_id` (large tenant base) | Unbounded | Exemplars; aggregate by `tenant_tier` |
| `request_id`, `trace_id` | Unbounded | Exemplars |
| `path` / `route` (raw URLs) | Unbounded | Template in code: `/users/:id` |
| `error_message`, `query`, `sql` | Unbounded text | Bounded `error_type` enum |
| `version`, `git_sha`, `image_tag` (on every metric) | Churn on every deploy | Info metric pattern |
| App-emitted `pod` (duplicating SD) | Should come from K8s service discovery, not code | Stop emitting it in code; keep the discovered `pod`. Never drop the real `pod` to cut cardinality - use Adaptive Metrics |
| `uid` (K8s) | Unbounded; regenerates on restart | Never map it into a label in the first place (leave it out of `relabel_configs`) |
| Application-emitted `instance`, `node`, `host` | Should come from scrape target | Stop emitting in code (removing an *exact* target-label duplicate at scrape is the only safe drop) |
| Dynamically-named label keys | Cannot be bounded | Use fixed keys with bounded values |
| Raw `status_code` on histograms | 14× amplification | Bucket to `status_class` (`2xx`, `4xx`, `5xx`) |

---

## When to Route Elsewhere

- **"Reduce my Grafana Cloud bill"** / **"reduce cardinality on series already ingested"** → use `adaptive-metrics` when installed; otherwise use `prometheus-grafana-triage` and keep the fix framed as post-ingest Adaptive Metrics, never `labeldrop` of distinguishing labels at scrape.
- **"Which metrics are driving my DPM?"** → use `prometheus-grafana-triage` with Grafana Cloud usage or PromQL evidence.
- **"My Prometheus is OOMing / scraping is failing right now"** → engage `prometheus-cardinality-troubleshooter` skill
- **"How do I write the query to find the bad metric?"** → use PromQL directly or route through `prometheus-grafana-triage`.
- **"How do I configure relabel rules in Alloy?"** → use Grafana Alloy docs or `prometheus-grafana-triage`; do not assume an `alloy` skill exists.

This skill's lane is **strategy and design**. Other skills own **diagnosis** and **operational remediation**.

## Workflow Coordination

This skill owns Prometheus label strategy design. It does not own general workflow state.

Use `vincent-workflow` for durable decisions, blockers, resume handoffs, known issues, commit/push/cleanup obligations, or project-local follow-up state.
Use `codex-closeout` for final chat delivery.
Use `codex-html-report` for durable proof artifacts.
Use `second-brain-context` only for cross-repo or future local-brain retrieval.
