---
name: agent-plan-backlog
description: Create, review, execute, or reconcile executor-grade implementation plans another agent can run without this chat. Use for /improve-style planning, a plans/ work queue for a weaker or cheaper model, stale-plan review, drift reconciliation, or sequencing one risky refactor into tiny safe steps. Not for PRD phase slicing (prd-to-plan) or issue drafts (prd-to-issues).
metadata:
  short-description: Build executor-grade plan backlogs
---

# Agent Plan Backlog

Use this skill when the plan is the product: the advisor agent writes self-contained implementation plans and leaves execution to a separate agent, a later session, or a human.

This adopts the useful mechanics from `shadcn/improve` without creating a parallel workflow system. Specialist skills still own discovery and diagnosis. This skill owns the executor-grade backlog. Read [references/upstream-notes.md](references/upstream-notes.md) when adapting the upstream `/improve` conventions.

## Use when

- Plain-English trigger examples: "turn this into plans another agent can execute", "make a backlog from these findings", "split this into safe autonomous agent passes", "review these stale plans and reconcile them", or "use improve-style planning, but do not implement yet". Use this route for `/improve`-style planning.
- when a thread review produces executor-grade skill, runbook, or AWS follow-up work
- an audit should produce implementation plans for a different model or future session
- a plan must be executable with no access to the advisor conversation
- a review or self-improvement pass produces multiple independent fixes that should become an agent-driven work queue
- the user wants automation-first follow-up but the work needs STOP conditions, proof gates, and scoped handoffs
- the work needs `plans/README.md`, numbered plan files, commit stamps, drift checks, STOP conditions, and done criteria
- an existing plan needs review, refresh, execution dispatch, or stale-plan reconciliation

## Do not use when

- the user wants the current agent to implement the fix directly in the current repo
- a short issue draft or normal refactor plan is enough
- the task is a PRD-to-phase breakdown without executor-grade file-level steps
- the work is only a chat answer, code review, or diagnosis
- there is only one obvious current-session fix and no future executor needs the plan

## Role split

- Advisor: performs recon, audits, vets findings, prioritizes, and writes plans.
- Executor: implements one selected plan in a later session, separate agent, or isolated worktree.
- Reviewer: the primary agent reviews executor output against the plan, reruns verification, checks scope, and reports a verdict.

The advisor should not edit source code while running this skill. Writes belong under `plans/` or, if that directory is already used for unrelated project planning, `advisor-plans/`.

## Workflow

### 1. Recon

Read the repo before judging it:

- `README`, `AGENTS.md`, `CONTRIBUTING`, and root config files
- package/build/test/lint/typecheck scripts
- CI config and deployment notes
- intent documents such as ADRs, PRDs, `CONTEXT.md`, `DESIGN.md`, and `PRODUCT.md` when present
- recent git history and churn hotspots when useful

Record exact verification commands. Do not guess. If the repo lacks a working verification command, make "establish verification baseline" the first candidate plan when relevant.

Record dependencies and execution order when findings depend on one another. Assign priority from evidence, blast radius, and unlock value, not from how easy a plan is to write.

### 2. Discover findings through specialist skills

Use the narrow skill that matches the discovery job:

- explore the codebase directly for boundary, coupling, and architecture opportunities
- the single-refactor planning mode below for one risky refactor that needs sequencing
- `triage-issue` for one bug or regression
- installed Codex Security plugin skills, `adversary-informed-defense`, or platform skills for domain-specific risks
- `prd-to-plan` for product phase slicing before executor-grade technical plans

This skill takes the selected finding or goal and turns it into executor-grade plan files.

### 3. Vet before planning

Before writing a plan, personally open every cited file and verify:

- the finding exists
- the line references and current behavior are accurate
- the plan is worth doing
- the fix can be verified
- the risk is known enough to bound

Record rejected findings in the index so they do not come back next run.

### 4. Write the backlog

Create or update:

```text
plans/
  README.md
  001-short-slug.md
  002-short-slug.md
```

In `plans/README.md`, keep a practical status table as the plan index so the backlog is machine and human readable:
| plan id | status | last verified | next action |
| --- | --- | --- | --- |
| 001-short-slug | TODO | 2026-01-01T00:00:00Z | reconcile scope, run drift check, then requeue |

If `plans/` already exists for unrelated planning, use `advisor-plans/` and say why.

Read [references/plan-template.md](references/plan-template.md) when writing a plan file.

Every plan must include:

- planned-at commit from `git rev-parse --short HEAD`
- purpose, concrete cost, and expected outcome
- exact in-scope and out-of-scope files
- current-state excerpts with `file:line` markers
- repo conventions and exemplar files to follow
- exact commands and expected results
- small ordered steps
- test plan
- dependencies, priority, and execution order when the backlog has more than one plan
- rollback path, revert command, or restore plan for risky changes
- machine-checkable done criteria
- STOP conditions specific to the plan
- maintenance notes for the reviewer
- execution notes section for the executor or reviewer to append results, deviations, skipped checks, and final status

Write for the weakest plausible executor. If a step depends on context from this chat, inline the context in the plan.
Do not paste entire files into plans. Use small excerpts with file and line references, and link to the source path where the executor should read the full context.

### 5. Reconcile instead of duplicating

When a backlog exists, read `plans/README.md` first.
Before assigning TODO work, detect overlapping in-scope files across queued plans. If two plans touch the same file, flag conflicting plans and either merge them or serialize execution so they do not run in parallel.

- `DONE`: spot-check cheap done criteria and mark verified when useful.
- `BLOCKED`: investigate the blocker, then refresh, replace, or reject the plan.
- `IN PROGRESS`: check whether an executor died mid-run and report the state.
- `TODO`: run the drift check. If in-scope files changed, refresh excerpts and the planned-at commit or reject the plan if the finding is gone.

Keep numbering monotonic. Do not reuse plan numbers.

### 6. Execute only as a reviewed handoff

If the user asks to execute a plan:

- prefer a separate executor agent in an isolated worktree when the runtime supports it
- inline the full plan in the executor prompt
- tell the executor to touch only in-scope files and stop on STOP conditions
- never merge, push, or commit to the user's branch without explicit approval
- review the diff yourself, rerun done criteria, check scope, and issue a verdict: approve, revise, or block

If isolated execution is not available, say so and hand over the plan for manual or current-session execution.

### 7. GitHub issues are distribution, not the source of truth

Only create issues when the user explicitly asks or uses an issue-publishing flag, and only as distribution copies.
Any published issue should link back to the plan and include a `Canonical plan` reference to the canonical plan file so issue readers can return to the source of truth.

Before publishing security, credential, or sensitive findings to a public repo, confirm visibility and get explicit approval.

## Sensitive Plan Handling

Executor plans must be useful without leaking authority. Do not copy secret values, credentials, tokens, private keys, cookies, kubeconfigs, browser sessions, or personal profile data into a plan. Name the required variable, file, secret name, or approval gate instead.

Pause for explicit approval before plans that would direct an executor to perform consent-changing action, final submission, public posting, destructive cleanup, billing changes, live infra mutation, DNS or firewall changes, credential movement, or secret-value handling.

For project-specific local lanes, keep private persona, customer, runtime, and secret-manager context in the relevant local skills or repo runbooks unless the plan needs a redacted reference to the authority boundary. Do not make a portable plan depend on private machine-local context that a fresh executor cannot access.

## Plan quality bar

A plan is not ready until:

- a fresh executor can run it without reading this chat
- every verification gate is a command with an expected result
- every STOP condition names a real risk
- no secret values are copied into the plan
- the drift check uses the planned-at commit and in-scope paths
- dependencies, priority, rollback, and execution notes are present when relevant
- a reviewer can understand the intent from the purpose and done criteria alone

## Single-refactor planning mode

When the job is planning one known refactor rather than a whole backlog, run this condensed sequence and default the deliverable to a Markdown plan or issue draft instead of numbered plan files:

1. Verify the problem in the codebase before planning: confirm the pain is real, find where the coupling or complexity lives, and note what behavior must be preserved. Challenge weak problem statements early.
2. Consider smaller alternatives first: a bug fix, an interface adjustment, or nothing. If the safest answer is "do less," say that clearly.
3. Write the plan boundary: what changes, what does not, what risks must be managed, and what verification proves safety. If test coverage is weak, make adding it part of the plan.
4. Break the work into tiny reviewable steps that each leave the codebase working. Prefer preparatory renames or moves, interface shims, additive transitions before deletions, and test additions near behavior boundaries.
5. Include an explicit out-of-scope section and a decision record.

Switch to the full backlog workflow above when the result must become numbered, commit-stamped plan files with STOP conditions for a separate executor.

## Related skills

- Use `triage-issue` to diagnose one bug before writing an executor-grade fix plan.
- Use `prd-to-plan` for product phase slicing; use this skill when each phase must become executor-grade technical work.
- Use `grill-with-docs` to pressure-test a plan before it enters the backlog.

## Workflow Coordination

This skill owns executor-grade plan files and plan reconciliation. It does not own general workflow state.

Use `vincent-workflow` for durable decisions, blockers, resume handoffs, known issues, commit/push/cleanup obligations, or project-local follow-up state. Use `codex-closeout` for final chat delivery. Use `codex-html-report` for durable reader-facing proof. Use `second-brain-context` only when the lesson should survive across repos, agents, or future local-brain retrieval.
