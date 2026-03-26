---
name: prd-to-issues
description: Break a PRD into small, independently shippable implementation issues using vertical slices. Use when the user wants a backlog, milestone breakdown, delivery phases, issue drafts, or actionable tickets from a product spec.
metadata:
  short-description: Convert a PRD into shippable issues
---

# PRD to Issues

Turn a PRD into a backlog of small, independently valuable slices. Default to Markdown issue drafts unless the user explicitly asks for GitHub issue creation.

## Workflow

### 1. Confirm the PRD

The PRD should already be in the conversation or available in a file. If it is not, ask for it.

### 2. Check the codebase

Before slicing, inspect the repo enough to understand:
- existing modules and boundaries
- likely integration points
- where vertical slices can land safely

### 3. Break work into vertical slices

Each issue should:
- deliver observable value on its own
- cut through the stack end-to-end when possible
- have clear acceptance criteria
- avoid depending on a long chain of prerequisite tickets

Avoid horizontal issues like "build DB layer", "build API layer", "build UI layer" unless the user specifically wants that structure.

### 4. Draft the issues

For each issue include:
- title
- why this slice exists
- scope
- acceptance criteria
- dependencies, if any
- implementation notes only if they are durable

Use a compact template:

```md
## <Issue Title>

### Outcome

### Scope

### Acceptance Criteria
- [ ] ...

### Dependencies
```

### 5. Optional GitHub creation

Do not create issues automatically.

If the user explicitly asks for GitHub issue creation:
- show the proposed issue list first if the breakdown is non-trivial
- then create them with `gh` once auth is confirmed

## Guidance

- Prefer too many small slices over a few oversized ones.
- Preserve architectural flexibility in early slices.
- If one issue exists only to support another and has no standalone value, merge it unless there is a strong reason not to.
