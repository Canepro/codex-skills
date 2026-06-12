---
name: observability-architecture
description: Design or review observability architecture across metrics, logs, traces, dashboards, alert routing, telemetry standards, retention, and ownership. Use when the user wants a durable monitoring strategy, telemetry platform design, signal governance, cost or retention trade-offs, or an observability stack review rather than live alert triage.
metadata:
  short-description: Design observability architecture
---

# Observability Architecture

Use this skill for durable telemetry-system design, not incident response.

## Use when

- designing a new monitoring or observability stack
- standardizing metrics, logs, and traces across teams
- fixing poor signal ownership or dashboard sprawl
- reviewing retention, sampling, cardinality, or storage trade-offs
- defining alert-routing and dashboard responsibilities

## Do not use when

- the main problem is a live alert or broken scrape. Use `prometheus-grafana-triage`.
- the main problem is an app or cluster incident. Use the appropriate triage skill.
- the user only wants SLIs and error budgets. Use `slo-sli-design`.

## Workflow

### 1. Start from decisions the system must support

Identify:
- what operators need to know quickly
- what engineers need for debugging
- what leadership needs for service health reporting
- what compliance or retention constraints exist

### 2. Define the signal model

Specify:
- required metrics
- structured logging expectations
- tracing boundaries
- correlation identifiers
- environment and ownership labels

### 3. Design the architecture

Cover:
- collection agents and exporters
- central vs federated storage
- retention and sampling
- alert evaluation location
- dashboard ownership
- on-call routing and escalation

### 4. Manage cost and cardinality explicitly

Do not leave these implicit:
- high-cardinality labels
- trace sampling strategy
- log retention tiers
- long-term metrics retention
- query performance constraints

### 5. Define ownership

Clarify:
- who owns instrumentation quality
- who owns alert rules
- who owns shared dashboards
- who can add or change telemetry schemas

## Output expectations

- Recommend an architecture, not just a tool list.
- Explain operational trade-offs.
- Separate mandatory baseline telemetry from optional nice-to-haves.
- Make cost and governance visible.

## Related specialist skills

- Use `prometheus-label-strategy` for Prometheus label schema, histogram label discipline, and cardinality prevention.
- Use `loki-label-analyzer` for Loki label schema, structured metadata choices, and log query performance.
- Use `alerting-irm` for Grafana alert routing, contact points, silences, IRM, and SLO alert provisioning.
- Use `promql` for query and recording-rule design.
- Use `loki` for LogQL and log-pipeline details.
- Use `assistant-mcp` when the architecture includes AI agents querying Grafana through MCP.

## References

- Read `references/pillars.md` for a working design checklist.

## Workflow Coordination

This skill owns its domain work. Use `vincent-workflow` for durable decisions, blockers, resume handoffs, known issues, commit/push/cleanup obligations, or project-local follow-up state. Use `codex-closeout` for final chat delivery, `codex-html-report` for durable reader-facing proof, and `second-brain-context` only for cross-repo or future local-brain retrieval.
