---
name: triage-issue
description: Investigate a code bug or regression in a repo, identify the likely root cause, and produce a fix plan or issue-quality diagnosis. Use when app behavior is broken and the cause is unclear, or the user wants diagnosis before implementation. Not for CI, Kubernetes, or observability incidents; use the matching domain triage skill.
metadata:
  short-description: Diagnose a bug and produce a fix plan
---

# Triage Issue

Investigate the problem with minimal back-and-forth, separate symptoms from causes, and leave the user with either a fix in progress or a durable issue-quality diagnosis.

This skill owns the output shape: a diagnosis or fix plan for one stated problem. When the investigation itself keeps thrashing (multiple failed fix attempts, unclear reproduction, pressure to guess), use the Superpowers `systematic-debugging` skill for its phased method if it is installed, then come back here to write up the result; otherwise continue with this skill's workflow. If the fix should be handed to another agent as a commit-stamped plan file, use `agent-plan-backlog` after diagnosis.

## Workflow

### 1. Capture the problem

If the report is vague, ask one short clarifying question. Then start investigating immediately.

Collect:
- what happens now
- what should happen instead
- how to reproduce, if known
- whether the user wants diagnosis only or an actual fix

### 2. Explore the codebase

Inspect the relevant entry points, supporting modules, tests, and recent file history.

Look for:
- where the bad behavior becomes observable
- the code path from input to failure
- whether this is a regression, missing validation, or a design mismatch
- similar working code paths elsewhere in the repo

### 3. Identify the root cause

Write down:
- the triggering conditions, with reproduction evidence gathered before fixing (a failing test, command output, or log excerpt that shows the bad behavior)
- for regressions, the regression range: the last known good version or commit, and the first known bad one
- the broken invariant or assumption
- the narrowest plausible change that would fix it
- the behaviors that need test coverage

Prefer behavior-level explanations over file-by-file narratives.

### 4. Choose the output

If the user wants a fix now:
- switch into implementation mode
- add or update tests first when practical
- keep the change minimal and verify the affected behavior
- re-run the reproduction and confirm the original failure is gone, not just that new tests pass

If the user wants planning only:
- produce a concise issue-ready draft with:
  - problem
  - expected behavior
  - root cause analysis
  - proposed fix direction
  - test plan
  - acceptance criteria

If the user wants an executor-grade plan, write the diagnosis first, then use `agent-plan-backlog` to create a self-contained `plans/NNN-*.md` file with current-state excerpts, verification gates, scope boundaries, and STOP conditions.

### 5. GitHub is optional

Do not create GitHub issues automatically.

If the user explicitly asks for a GitHub issue:
- draft the issue body first
- use `gh` only after confirming auth and only because the user asked

## Guidance

- Prefer one strong diagnosis over a long list of guesses.
- Avoid coupling the final write-up to fragile file paths unless the user asked for implementation detail.
- If the diagnosis is still uncertain, state the leading hypothesis and the missing evidence clearly.

## Workflow Coordination

This skill owns its domain work. Use `vincent-workflow` for durable decisions, blockers, resume handoffs, known issues, commit/push/cleanup obligations, or project-local follow-up state. Use `codex-closeout` for final chat delivery, `codex-html-report` for durable reader-facing proof, and `second-brain-context` only for cross-repo or future local-brain retrieval.
