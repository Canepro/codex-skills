# Observability Architecture Checklist

## Metrics

- Core service health metrics
- Saturation and capacity signals
- Business or workflow outcome metrics
- Label hygiene and cardinality controls

## Logs

- Structured format
- Correlation IDs
- Clear severity conventions
- Retention by value, not habit

## Traces

- Service boundaries and span naming
- Sampling strategy
- Trace-log-metric correlation
- High-latency and error workflow visibility

## Alerts

- Actionable ownership
- Clear severity policy
- Route to the team that can act
- Tie to symptoms or SLO burn where possible

## Dashboards

- Purpose-specific, not vanity walls
- Shared conventions for names and filters
- Clear ownership and review cadence

## Governance

- Who can create global rules
- Who can change telemetry schemas
- Cost review process
- Retention review process
