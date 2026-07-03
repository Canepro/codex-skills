---
name: improve-codebase-architecture
description: Explore a codebase for architectural refactors that deepen modules and reduce coupling. Use when the user wants refactoring ideas, architecture review, maintainability improvements, clearer boundaries, or a codebase that is easier for humans and agents to navigate. Not for sequencing one already-chosen refactor (request-refactor-plan).
metadata:
  short-description: Find and frame architectural improvement opportunities
---

# Improve Codebase Architecture

Explore the codebase as a maintainer would, notice where understanding breaks down, and turn that friction into concrete architectural recommendations. When a selected opportunity needs executor-grade plan files, hand it to `agent-plan-backlog`.

## Workflow

### 1. Explore for friction

Inspect the codebase broadly enough to notice:
- concepts spread across too many small files
- shallow modules whose interfaces are almost as complex as their internals
- seams where integration bugs are likely
- code that is hard to test except through fragile internals
- repeated orchestration logic that should probably live behind one boundary

Track where these patterns show up in concrete symbol-level evidence. Note runtime behavior at boundary crossings such as request flow, scheduling, retries, state transitions, startup/shutdown, and error propagation, so the pain is measurable and grounded.
The friction you experience is the signal.

### 2. Present candidates

Give the user a numbered list of architectural opportunities. For each candidate include:
- cluster: the modules or concepts involved
- concrete evidence: cite concrete files and symbol-level evidence such as entrypoints, classes, functions, handlers, interfaces, and call sites
- runtime behavior: what runtime behavior currently crosses the boundary and how a redesign changes latency, failure handling, consistency, or observability
- why they are coupled
- dependency category: load [REFERENCE.md](REFERENCE.md) when assigning a dependency category
- testing impact: which boundary tests would become possible
- prioritization signals:
  - expected payoff: estimated improvement in coupling, reliability, readability, and change speed
  - blast radius: scope of modules, environments, and deployment paths impacted
  - implementation risk: migration complexity, compatibility hazards, and rollback cost

Do not jump straight to a final design for every candidate. Help the user choose where to go deeper.

### 3. Frame the chosen problem

Once the user picks a candidate, explain:
- what constraints the new boundary must satisfy
- what dependencies it must own or hide
- what should remain stable for callers
- a rough interface sketch if needed to ground the discussion

### 4. Design alternatives

For the chosen module boundary, run the `design-an-interface` skill to generate and compare multiple interface directions. If it is not installed, sketch 2-3 alternatives inline with usage examples and trade-offs.

### 5. Recommend a direction

After comparison, recommend one direction or a hybrid. Be opinionated and explain why.

### 6. Produce an RFC or issue draft if needed

Default to a Markdown recommendation or RFC draft.

If the user wants a backlog of implementation plans for another agent, use `agent-plan-backlog` after the architecture opportunity is selected and vetted. This skill owns architecture discovery and recommendation; `agent-plan-backlog` owns commit-stamped plan files, STOP conditions, drift checks, and reconciliation.

If the user explicitly wants a GitHub issue:
- draft it first
- only then create it with `gh` if auth is available

## Guidance

- Prefer durable architecture language over file-path-level instructions.
- Focus on boundaries, responsibilities, and testability.
- Replace shallow internal tests with stronger boundary tests when recommending deepened modules.

## Safety boundaries

If recommendations may touch secret handling, credential handling, token flows, private key paths, or Infisical-backed secret usage, do not echo values, do not expose secret or credential artifacts, and keep all outputs redacted.

## Workflow Coordination

This skill owns its domain work. Use `agent-plan-backlog` for executor-grade plan files and plan reconciliation. Use `vincent-workflow` for durable decisions, blockers, resume handoffs, known issues, commit/push/cleanup obligations, or project-local follow-up state. Use `codex-closeout` for final chat delivery, `codex-html-report` for durable reader-facing proof, and `second-brain-context` only for cross-repo or future local-brain retrieval.
