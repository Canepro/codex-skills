---
name: request-refactor-plan
description: Create a detailed, low-risk refactor plan with tiny, safe steps based on codebase exploration and the user's goals. Use when planning a risky refactor, drafting a refactoring RFC, sequencing an incremental rewrite, or breaking a large cleanup into shippable commits.
metadata:
  short-description: Plan an incremental refactor
---

# Request Refactor Plan

Build a refactor plan that is technically credible, incrementally shippable, and explicit about what stays out of scope. Use `agent-plan-backlog` when the result must become numbered, commit-stamped plan files for another agent to execute later.

## Workflow

### 1. Understand the problem

Get a detailed description of:
- the current pain
- why a refactor is needed now
- any proposed solutions or constraints

If the problem statement is weak, challenge it early.

### 2. Verify in the codebase

Inspect the relevant modules and tests to confirm:
- the problem is real
- where the coupling or complexity lives
- what current behavior must be preserved

### 3. Explore alternatives

Before committing to a refactor, consider whether:
- a small bug fix would solve it
- an interface adjustment would be enough
- the proposed refactor is larger than the actual problem

### 4. Define the plan boundary

Write down:
- what will change
- what will not change
- what risks must be managed
- what tests or verification will prove safety

### 5. Break it into tiny steps

Produce a plan of small, reviewable steps. Each step should leave the codebase in a working state.

Prefer:
- preparatory renames or moves
- interface shims
- additive transitions before deletions
- test additions near behavior boundaries

### 6. Produce the deliverable

Default to a Markdown plan or issue draft with sections like:
- problem statement
- solution direction
- incremental steps
- decision record
- testing decisions
- out of scope

If the user wants the plan written into `plans/` for a weaker executor, switch to `agent-plan-backlog`. This skill owns refactor reasoning and sequence design; `agent-plan-backlog` owns self-contained plan files, drift checks, STOP conditions, done criteria, and reconcile.

Do not over-index on exact file paths unless the user explicitly wants implementation-level instructions.

### 7. GitHub is optional

Do not create a GitHub issue automatically.

If the user explicitly asks for one:
- draft the body first
- then use `gh` only after confirming auth

## Guidance

- A refactor plan should reduce risk, not just describe the destination.
- If test coverage is weak, say so and make verification part of the plan.
- If the safest answer is "do less," say that clearly.

## Workflow Coordination

This skill owns its domain work. Use `vincent-workflow` for durable decisions, blockers, resume handoffs, known issues, commit/push/cleanup obligations, or project-local follow-up state. Use `codex-closeout` for final chat delivery, `codex-html-report` for durable reader-facing proof, and `second-brain-context` only for cross-repo or future local-brain retrieval.
