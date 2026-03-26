---
name: triage-issue
description: Investigate a bug or regression, identify the likely root cause, and produce a durable fix plan or issue-quality diagnosis. Use when behavior is broken, a regression needs reproducing, the root cause is unclear, or the user wants diagnosis before implementation.
metadata:
  short-description: Diagnose a bug and produce a fix plan
---

# Triage Issue

Investigate the problem with minimal back-and-forth, separate symptoms from causes, and leave the user with either a fix in progress or a durable issue-quality diagnosis.

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
- the triggering conditions
- the broken invariant or assumption
- the narrowest plausible change that would fix it
- the behaviors that need test coverage

Prefer behavior-level explanations over file-by-file narratives.

### 4. Choose the output

If the user wants a fix now:
- switch into implementation mode
- add or update tests first when practical
- keep the change minimal and verify the affected behavior

If the user wants planning only:
- produce a concise issue-ready draft with:
  - problem
  - expected behavior
  - root cause analysis
  - proposed fix direction
  - test plan
  - acceptance criteria

### 5. GitHub is optional

Do not create GitHub issues automatically.

If the user explicitly asks for a GitHub issue:
- draft the issue body first
- use `gh` only after confirming auth and only because the user asked

## Guidance

- Prefer one strong diagnosis over a long list of guesses.
- Avoid coupling the final write-up to fragile file paths unless the user asked for implementation detail.
- If the diagnosis is still uncertain, state the leading hypothesis and the missing evidence clearly.
