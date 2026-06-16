---
name: prometheus-grafana-triage
description: Investigate Prometheus, Grafana, and Alertmanager incidents by separating real platform problems from scrape failures and bad rules. Use when alerts fire unexpectedly, targets are down, dashboards look stale, Alertmanager is noisy, or PromQL or rule logic may be wrong.
metadata:
  short-description: Triage alerts, scrape failures, and observability noise
---

# Prometheus Grafana Triage

Treat alerting problems as one of three classes: a real platform issue, a broken scrape, or a bad rule. Verify which one it is before touching manifests.

## Use when

- Grafana alerts are firing and the user wants to know why
- Prometheus scrape targets are down
- Alertmanager is noisy or seems stale
- Grafana dashboards disagree with current cluster state
- the user suspects a rule bug or stale metric logic

## Do not use when

- The primary problem is a generic Kubernetes runtime incident with no monitoring angle. Use `k8s-sre-triage`.
- The primary problem is a failing CI job or deployment pipeline. Use `ci-pipeline-triage`.
- The request is for dashboard design or long-term metrics architecture rather than incident triage.

## Workflow

### 1. Check the live monitoring stack

Verify:
- which cluster actually owns the alert evaluation or scrape path
- the expected state for each cluster, spoke, or optional runtime
- Grafana health
- Prometheus health
- Alertmanager health
- whether you are querying the hub or the spoke agent

Before switching contexts or querying random clusters, identify the source of truth:
- the cluster label on the alert or target
- the Prometheus or Alertmanager instance that is currently evaluating the rule
- whether the data comes from a hub-and-spoke flow or a local Prometheus
- repo docs, runbooks, maintenance schedules, or automation state that say a target is intentionally stopped, parked, retired, or on-demand

Do not assume the dashboard reflects the current truth until Prometheus and its scrape path are confirmed healthy.

### 2. Classify expected state before declaring an incident

For hub-and-spoke or cost-controlled environments, classify every relevant target before interpreting missing metrics or unreachable endpoints:
- `live`: expected to be online now
- `parked`: intentionally shut down, scaled to zero, paused, or on-demand
- `retired`: intentionally removed from service but still visible in old dashboards, labels, or Argo CD apps
- `unknown intent`: no current evidence says whether the target should be online

Use repo-local evidence first:
- README and architecture docs
- operations runbooks
- maintenance or startup/shutdown docs
- GitOps application descriptions
- automation schedules
- recent reports only as secondary context

For a parked or retired target, do not report absent metrics, DNS failure, Argo CD `Unknown`, or `up == 0` as a live platform incident by itself. Report it as expected offline state, stale visibility, or an expected blind spot.
In hub-and-spoke environments, before treating missing hub data as target failure, check remote write and federation flow health first. Confirm whether there is federation lag, and inspect remote write queue depth and backfill status so ingest delay is not mistaken for a real outage.

Escalate an offline target only when:
- the user asked for that target to be checked as online
- a job, migration, maintenance window, or startup runbook expects it to be online
- recent telemetry shows it was online and then dropped unexpectedly
- the shutdown/startup automation itself reports failure

Example: if an AKS spoke is documented as on-demand for cost control, then missing AKS samples and Argo CD `Healthy/Unknown` are expected while it is parked. The SRE finding is the OKE hub health plus the parked-spoke state, not an AKS outage.

### 3. Inspect active alerts

Capture:
- alert name
- state: pending vs firing
- cluster label
- severity
- summary and description

Separate:
- active alert in Alertmanager
- active rule evaluation in Prometheus
- stale visualization in Grafana

For container restart or `OOMKilled` alerts, verify the runtime event separately from the alert freshness:
- current pod `restartCount`
- `lastState.reason`
- `lastState.terminated.exitCode`
- previous container logs when available

Bundled helpers:
- `scripts/alert_summary.py` for active alerts from Prometheus or Alertmanager
- `scripts/prom_target_failures.py` for current scrape failures with `lastError`

### 4. Check scrape health

When `up == 0`, inspect:
- target instance
- job name
- scrape URL
- `lastError`

Confirm the endpoint directly where possible:
- wrong path often returns `404`
- wrong port or bind address often returns `connection refused`
- missing auth returns `401` or `403`

### 5. Check the rule logic

Look for common rule problems:
- using `count(metric)` when the correct intent is `sum(metric == 1)`
- alerting on sticky gauges like `last_terminated_reason == 1`
- thresholds that count metric series rather than objects
- rules evaluated against the wrong cluster label

Prefer a corrected query over ad hoc silencing when the rule itself is wrong.
After any PromQL or rule fix, run deterministic rule validation with `promtool check rules` and `promtool test rules` (or equivalent rule tests) before closing the fix loop.

For OOM alerts, avoid treating a sticky `last_terminated_reason` gauge as proof that the problem is still active. A real OOM event can coexist with a stale firing alert.

### 6. Decide the fix path

Pick one:
- runtime issue: hand off to `k8s-sre-triage`
- scrape config issue: fix service, ServiceMonitor, scrape config, port, or path
- rule issue: fix the PromQL and docs
- temporary operational noise: before adding or updating a silence, inspect alertmanager notification policy and route configuration for routing, grouping, repeat interval, and inhibition behavior to ensure the silence maps to the right route scope
- expected offline state: document the parked, retired, or on-demand state and recommend checks only for the next startup or intended-online window

### 7. Verify

After the change:
- target health becomes `up`
- corrected query returns the expected count
- firing or pending state clears as expected
- no important alert coverage was removed accidentally
- changed rules pass deterministic checks such as `promtool check rules` and `promtool test rules`
- expected-state classification is backed by a current repo doc, runbook, automation schedule, or explicit user instruction

## Guidance

- Query the system that actually scrapes the target. In a hub-and-spoke design, the spoke agent often holds the real `lastError`.
- Do not trust one layer alone. Compare cluster reality, Prometheus target health, and alert logic.
- Do not collapse "unreachable" into "broken" until expected state is known. On-demand infrastructure often looks broken from dashboards while parked.
- If the rule source lives in a different repo than the workload, say so clearly and patch the right repo.
- `container_memory_working_set_bytes` is supporting evidence, not definitive proof of an exact cgroup kill threshold or kill timestamp. Use it to support an OOM diagnosis, not to overstate one.
- When the evidence proves a real event but not the precise trigger, say so. Distinguish “real incident” from “fully explained incident.”

## Related specialist skills

Use these for deeper Grafana-specific work after the incident shape is clear:
- `promql` for query correctness, histograms, recording rules, and slow PromQL.
- `loki` for LogQL, parsers, log-pipeline behavior, and Loki-specific troubleshooting.
- `alerting-irm` for Grafana alert rules, contact points, notification policies, silences, SLOs, and IRM.
- `prometheus-cardinality-troubleshooter` for active series explosions, Prometheus OOM, slow queries, ingest limits, or DPM fires.
- `prometheus-label-strategy` for preventing cardinality problems in instrumentation or scrape target labels.
- `loki-label-analyzer` for Loki label strategy and slow log queries caused by bad labels.
- `assistant-mcp` for Grafana MCP setup or agent-to-Grafana connection work.

## References

- Read `references/triage-patterns.md` for common scrape and rule failure patterns.

## Scripts

### `scripts/alert_summary.py`

Summarizes active alerts from Prometheus or Alertmanager.

Usage:
```bash
python3 "${CODEX_HOME:-$HOME/.codex}/skills/prometheus-grafana-triage/scripts/alert_summary.py" --prometheus-url http://127.0.0.1:9090
python3 "${CODEX_HOME:-$HOME/.codex}/skills/prometheus-grafana-triage/scripts/alert_summary.py" --alertmanager-url http://127.0.0.1:9093
```

### `scripts/prom_target_failures.py`

Lists non-healthy Prometheus targets with cluster, job, scrape URL, and `lastError`.

Usage:
```bash
python3 "${CODEX_HOME:-$HOME/.codex}/skills/prometheus-grafana-triage/scripts/prom_target_failures.py" --prometheus-url http://127.0.0.1:9090
```

## Workflow Coordination

This skill owns its domain work. Use `vincent-workflow` for durable decisions, blockers, resume handoffs, known issues, commit/push/cleanup obligations, or project-local follow-up state. Use `codex-closeout` for final chat delivery, `codex-html-report` for durable reader-facing proof, and `second-brain-context` only for cross-repo or future local-brain retrieval.
