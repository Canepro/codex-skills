---
name: prometheus-grafana-triage
description: Use when the user asks to investigate Grafana alerts, Prometheus scrape failures, Alertmanager noise, stale firing rules, bad PromQL, or observability health; verify the live alert state first, separate rule bugs from target failures, and recommend or implement the correct fix path.
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
- Grafana health
- Prometheus health
- Alertmanager health
- whether you are querying the hub or the spoke agent

Before switching contexts or querying random clusters, identify the source of truth:
- the cluster label on the alert or target
- the Prometheus or Alertmanager instance that is currently evaluating the rule
- whether the data comes from a hub-and-spoke flow or a local Prometheus

Do not assume the dashboard reflects the current truth until Prometheus and its scrape path are confirmed healthy.

### 2. Inspect active alerts

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

### 3. Check scrape health

When `up == 0`, inspect:
- target instance
- job name
- scrape URL
- `lastError`

Confirm the endpoint directly where possible:
- wrong path often returns `404`
- wrong port or bind address often returns `connection refused`
- missing auth returns `401` or `403`

### 4. Check the rule logic

Look for common rule problems:
- using `count(metric)` when the correct intent is `sum(metric == 1)`
- alerting on sticky gauges like `last_terminated_reason == 1`
- thresholds that count metric series rather than objects
- rules evaluated against the wrong cluster label

Prefer a corrected query over ad hoc silencing when the rule itself is wrong.

For OOM alerts, avoid treating a sticky `last_terminated_reason` gauge as proof that the problem is still active. A real OOM event can coexist with a stale firing alert.

### 5. Decide the fix path

Pick one:
- runtime issue: hand off to `k8s-sre-triage`
- scrape config issue: fix service, ServiceMonitor, scrape config, port, or path
- rule issue: fix the PromQL and docs
- temporary operational noise: add or update a silence only if the rule is otherwise correct

### 6. Verify

After the change:
- target health becomes `up`
- corrected query returns the expected count
- firing or pending state clears as expected
- no important alert coverage was removed accidentally

## Guidance

- Query the system that actually scrapes the target. In a hub-and-spoke design, the spoke agent often holds the real `lastError`.
- Do not trust one layer alone. Compare cluster reality, Prometheus target health, and alert logic.
- If the rule source lives in a different repo than the workload, say so clearly and patch the right repo.
- `container_memory_working_set_bytes` is supporting evidence, not definitive proof of an exact cgroup kill threshold or kill timestamp. Use it to support an OOM diagnosis, not to overstate one.
- When the evidence proves a real event but not the precise trigger, say so. Distinguish “real incident” from “fully explained incident.”

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
