---
name: write-a-prd
description: Turn a rough feature idea into a concise, implementation-ready product requirements document through targeted questioning, codebase exploration, and scope tightening. Use when the user wants to write a PRD, sharpen a proposal, define success criteria, or turn an idea into a spec.
metadata:
  short-description: Write a practical PRD
---

# Write a PRD

Create a PRD that is clear enough to plan from, but lean enough to survive implementation. Default to a Markdown draft unless the user explicitly wants a GitHub issue or another destination.

## Workflow

### 1. Establish the problem

Learn:
- who the user or operator is
- what problem they have
- why it matters now
- what success looks like

Ask only the questions needed to remove ambiguity.

### 2. Explore the codebase when relevant

If the PRD is for an existing product, inspect the current architecture, workflows, and constraints before finalizing requirements.

Verify:
- whether similar features already exist
- what boundaries or integrations are already present
- obvious technical constraints that should affect scope

### 3. Tighten scope

Separate:
- goals
- non-goals
- hard requirements
- open questions
- rollout or migration concerns

Challenge vague requests. Convert mood words into observable outcomes.

### 4. Produce the PRD

Use a structure like:

```md
# PRD: <Feature Name>

## Problem

## Users / Operators

## Goals

## Non-goals

## User stories or key workflows

## Functional requirements

## Constraints

## Success criteria

## Rollout / migration

## Open questions
```

Keep requirements testable and user-facing. Avoid premature implementation detail unless it is a hard constraint.

### 5. Optional GitHub output

Do not create a GitHub issue automatically.

If the user explicitly asks for issue creation:
- draft the body first
- then use `gh` if auth is available

## Guidance

- Prefer a usable document over a maximal one.
- If the user already supplied a draft, rewrite and tighten it rather than starting over.
- If there is major product uncertainty, make that uncertainty explicit instead of hiding it in vague language.
