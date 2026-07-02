---
name: slo-sli-design
description: Define service level indicators, service level objectives, and error budgets that reflect real user outcomes. Use when the user wants SLIs or SLOs for APIs, background jobs, platforms, or user journeys, needs alerts tied to reliability targets, or wants to replace vague uptime goals with measurable service health. For Grafana SLO provisioning and burn-rate alert configuration, use alerting-irm.
metadata:
  short-description: Define SLIs, SLOs, and error budgets
---

# SLO SLI Design

Use this skill to turn vague reliability expectations into measurable commitments.

## Use when

- the team needs SLIs and SLOs for a service or user journey
- alerting should be tied to error-budget consumption
- uptime goals feel too generic to guide engineering decisions
- platform or product teams need a common reliability language

## Do not use when

- the main task is designing the whole observability stack. Use `observability-architecture`.
- the main task is triaging current alerts. Use `prometheus-grafana-triage`.
- the user only wants generic metrics lists without service-level commitments.

## Workflow

### 1. Start with the user-visible promise

Define:
- who the user is
- what successful experience they expect
- what failure means from their perspective

Do not start from whatever metrics already exist.

### 2. Pick candidate indicators

Common classes:
- availability / success rate
- latency
- freshness
- correctness
- throughput completion for scheduled work

Prefer indicators that map to user harm, not internal convenience.

### 3. Choose the measurement source

Decide whether the SLI should come from:
- edge or load balancer metrics
- application metrics
- synthetic probes
- job-completion events
- user-journey instrumentation

Be explicit about blind spots in each source.

### 4. Set the objective and budget

Specify:
- target percentage or threshold
- rolling window
- error budget implied by the objective
- exclusions or maintenance policies

The goal should be strict enough to drive trade-offs, not ceremonial.

### 5. Tie alerts to budget burn

Prefer:
- fast-burn alerts for sharp regressions
- slow-burn alerts for sustained reliability erosion

Do not page people on every local dip if it does not threaten the objective.

### 6. Define adoption

Include:
- dashboards or scorecards
- owner and review cadence
- how the SLO changes release or incident decisions
- when an SLO should be revised

## Guidance

- One good SLO is better than five vague ones.
- Separate internal component health from user-facing service health.
- If a metric cannot drive a decision, it is probably not an SLI.

## Related specialist skills

- Use `promql` to write or validate SLI queries, error ratios, latency percentiles, recording rules, and burn-rate expressions.
- Use `alerting-irm` to turn SLOs into Grafana-managed alerts, notification policies, silences, and IRM workflows. Grafana SLO provisioning and burn-rate alert configuration belong there, not here.
- Use `observability-architecture` when the measurement source, ownership model, or retention strategy is not settled.

## References

- Read `references/sli-patterns.md` for common indicator shapes and alert patterns.

## Workflow Coordination

This skill owns its domain work. Use `vincent-workflow` for durable decisions, blockers, resume handoffs, known issues, commit/push/cleanup obligations, or project-local follow-up state. Use `codex-closeout` for final chat delivery, `codex-html-report` for durable reader-facing proof, and `second-brain-context` only for cross-repo or future local-brain retrieval.
