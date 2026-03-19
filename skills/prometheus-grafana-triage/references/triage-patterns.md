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

Better when you mean recent events:
```promql
changes(kube_pod_container_status_last_terminated_reason{reason="OOMKilled"}[15m]) > 0
```

## Hub and spoke reminder

In a multi-cluster design:
- the central Prometheus may show the alert
- the spoke Prometheus agent may have the authoritative `lastError`

Query the right layer before concluding the target is healthy or broken.

