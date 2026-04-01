---
name: naming-quality
description: Improve or review names for files, modules, exported identifiers, routes, API fields, fixtures, environment labels, and user-facing copy. Use when naming or renaming something important, cleaning up terminology drift, or choosing durable vocabulary that should stay clear across code, docs, and product surfaces.
metadata:
  short-description: Choose clearer, more durable names
---

# Naming Quality

Choose names that survive contact with real usage, not just the current patch.

## Use when

- creating or renaming files, modules, components, routes, or exported identifiers
- tightening API field names, CLI flags, env vars, or fixture names
- cleaning up environment terminology across docs and code
- reviewing whether an existing name is misleading, temporary, too local, or too implementation-shaped

## Do not use when

- the name is fixed by an external standard, upstream API, or protocol
- the task is only cosmetic and does not improve understanding
- the current name is ugly but already the stable public contract and a rename would create more churn than value

## Workflow

### 1. Define the naming job

Be explicit about:

- what is being named
- who reads or types the name
- whether it is internal, user-facing, or part of a public contract
- how expensive a future rename would be

### 2. Verify the real behavior first

Read the code, docs, tests, or UI that the name represents.

Do not optimize a name around a mistaken mental model.

### 3. Prefer durable meaning over temporary provenance

Good names usually prefer:

- role over mechanism
- user meaning over implementation detail
- stable behavior over current hosting or machine specifics
- scenario-based language over local workstation names

Examples:

- prefer `validation environment` over a resource label like `staging` when the role has changed
- prefer `payments-bundle.json` over a machine-specific fixture name when the scenario matters more than the laptop

### 4. Keep resource names and canonical vocabulary separate

When existing infrastructure names are already deployed:

- keep the resource identifier if changing it is costly
- but do not let that identifier become the canonical product vocabulary

Document the distinction explicitly when needed.

### 5. Test candidate names

A strong name should pass most of these checks:

- someone new can predict what it means
- it does not become false after the next migration
- it is not tied to one provider unless provider-specificity is the point
- it is short enough to scan in code review and logs
- it does not collide with nearby concepts

### 6. Rename completely

If a rename is worth doing, update all relevant touchpoints:

- code
- tests
- docs
- scripts
- prompts or labels
- config or contract notes

Avoid half-renames that leave the old concept alive in adjacent files.

### 7. When unsure, produce a short option set

If the right name is not obvious, give 2 or 3 candidates with a one-line tradeoff for each.

Do not generate a long brainstorm list.

## Guidance

- Prefer names that still make sense when open-sourced.
- Treat naming as product quality, not polish.
- If the safest answer is to keep the current public contract and only improve internal labels, say so clearly.
