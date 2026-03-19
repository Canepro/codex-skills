# Prometheus and Grafana Triage Patterns

## First split: target vs rule

Ask:
- Is the target actually down?
- Is the rule mathematically wrong?
- Is the alert stale because it uses a sticky gauge?

Do not start with silences.

## Common scrape failures

### `404 Not Found`

Usually means:
- wrong metrics path
- scraping an HTML or JSON endpoint as if it were Prometheus text
- service annotation missing `/metrics`

### `connection refused`

Usually means:
- wrong port
- app binds locally inside the container but not to pod IP
- service points to a port that exists in spec but not in practice for remote scraping

### `401` or `403`

Usually means:
- auth required for metrics endpoint
- bearer token/basic auth missing
- network policy or proxy auth path involved

## Common rule bugs

### Counting series instead of objects

Bad pattern:
```promql
count(kube_pod_status_phase{phase="Succeeded"})
```

Better when you mean actual current pods in that phase:
```promql
sum(kube_pod_status_phase{phase="Succeeded"} == 1)
```

### Sticky OOMKilled alert

Bad pattern:
```promql
kube_pod_container_status_last_terminated_reason{reason="OOMKilled"} == 1
```

Better when you mean recent restart events caused by OOM:
```promql
increase(kube_pod_container_status_restarts_total[15m]) > 0
and on (namespace, pod, container, cluster)
kube_pod_container_status_last_terminated_reason{reason="OOMKilled"} == 1
```

Investigation order for OOM alerts:
- verify the active alert on the Prometheus or Alertmanager instance that owns it
- verify the pod or container state in Kubernetes: `restartCount`, `lastState.reason`, `exitCode`
- pull previous logs from the correct namespace if the container restarted
- use memory metrics as supporting evidence only
- conclude separately:
  - was there a real OOM event?
  - is the alert still correctly firing now?

## Hub and spoke reminder

In a multi-cluster design:
- the central Prometheus may show the alert
- the spoke Prometheus agent may have the authoritative `lastError`

Query the right layer before concluding the target is healthy or broken. Start by identifying which cluster and which monitoring system actually owns the alert.
