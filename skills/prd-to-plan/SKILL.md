---
name: prd-to-plan
description: Turn a PRD into a phased implementation plan of tracer-bullet vertical slices, saved as one Markdown file in ./plans/. Use for a build plan, implementation phases, or plan-from-PRD. Not for issue or ticket drafts (prd-to-issues) or executor-grade agent plans (agent-plan-backlog).
---

# PRD to Plan

Break a PRD into a phased implementation plan using vertical slices (tracer bullets). Output is a Markdown file in `./plans/`. Use `agent-plan-backlog` when approved phases need to become executor-grade technical plans for another model or later session. Use `prd-to-issues` when the user wants tickets or issue drafts instead of a single plan file.

## Process

### 1. Confirm the PRD is in context

The PRD should already be in the conversation. If it isn't, ask the user to paste it or point you to the file.

### 2. Explore the codebase

If you have not already explored the codebase, do so to understand the current architecture, existing patterns, and integration layers.

### 3. Identify durable architectural decisions

Before slicing, identify high-level decisions that are unlikely to change throughout implementation:

- Route structures / URL patterns
- Database schema shape
- Key data models
- Authentication / authorization approach
- Third-party service boundaries

These go in the plan header so every phase can reference them.

### 4. Draft vertical slices

Break the PRD into **tracer bullet** phases. Each phase is a thin vertical slice that cuts through ALL integration layers end-to-end, NOT a horizontal slice of one layer.

Before naming a sequence, define the intended **phase order** explicitly so dependencies are clear. Each phase should be independently verifiable, but only after its prerequisite work is complete.

<vertical-slice-rules>
- Each slice delivers a narrow but COMPLETE path through every layer (schema, API, UI, tests)
- A completed slice is demoable or verifiable on its own
- Prefer many thin slices over few thick ones
- Do NOT include specific file names, function names, or implementation details that are likely to change as later phases are built
- DO include durable decisions: route paths, schema shapes, data model names
- Document **dependencies** per slice: what must be done before this slice starts and what this slice **unblocks** for later work
</vertical-slice-rules>

### 5. Capture assumptions and unresolved questions

Before final phase sequencing, write a short set of assumptions and unresolved PRD items. These must be cleared or explicitly accepted before implementation phases are finalized.

- **Assumptions**: what you are treating as fixed for planning (environments, integrations, constraints)
- **Open questions**: unresolved user intent or product decisions
- **Unresolved** items: known unknowns that can still block safe sequencing

Do not finalize the phase order while unresolved items remain unacknowledged.

### 6. Quiz the user

Present the proposed breakdown as a numbered list. For each phase show:

- **Title**: short descriptive name
- **User stories covered**: which user stories from the PRD this addresses

Ask the user:

- Does the granularity feel right? (too coarse / too fine)
- Should any phases be merged or split further?
- Which assumptions, open questions, or unresolved items need resolution before implementation starts?

Iterate until the user approves the breakdown.

### 7. Write the plan file

Create `./plans/` if it doesn't exist. Write the plan as a Markdown file named after the feature (e.g. `./plans/user-onboarding.md`). Use the template below.

<plan-template>
# Plan: <Feature Name>

> Source PRD: <brief identifier or link>

## Architectural decisions

Durable decisions that apply across all phases:

- **Routes**: ...
- **Schema**: ...
- **Key models**: ...
- (add/remove sections as appropriate)

## Assumptions and unresolved open questions

- **Assumptions**: ...
- **Open questions (unresolved)**: ...

## Phase order and dependencies

State the explicit **phase order** and **dependencies** up front, and note what each phase **unblocks** next. Keep every slice independently verifiable once its prerequisites are satisfied.

---

## Phase 1: <Title>

**User stories**: <list from PRD>

### Dependency and unblock notes

- **Dependencies**: ...
- **Unblocks**: ...

### What to build

A concise description of this vertical slice. Describe the end-to-end behavior, not layer-by-layer implementation.

### Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

---

## Phase 2: <Title>

**User stories**: <list from PRD>

### What to build

...

### Acceptance criteria

- [ ] ...

<!-- Repeat for each phase -->
</plan-template>

## Workflow Coordination

This skill owns PRD-to-phase planning. Use `agent-plan-backlog` when a phase must become a self-contained technical execution plan with drift checks, STOP conditions, and done criteria for another agent. Use `vincent-workflow` for durable decisions, blockers, resume handoffs, known issues, commit/push/cleanup obligations, or project-local follow-up state. Use `codex-closeout` for final chat delivery, `codex-html-report` for durable reader-facing proof, and `second-brain-context` only for cross-repo or future local-brain retrieval.
