---
name: naming-quality
description: Improve or review names for files, modules, identifiers, routes, API fields, env labels, and user-facing copy. Use when the user asks what to call something, wants to rename something important, or needs durable vocabulary across code, docs, logs, and operator workflows. Not when the name is fixed by an external standard.
metadata:
  short-description: Choose clearer, more durable names
---

# Naming Quality

Choose names that survive contact with real usage, not just the current patch.

## Use when

- the user asks "what should we call this?", "is this name right?", or "help me name this"
- creating or renaming files, modules, components, routes, or exported identifiers
- tightening API field names, CLI flags, env vars, or fixture names
- cleaning up environment terminology across docs and code
- reviewing whether an existing name is misleading, temporary, too local, or too implementation-shaped
- naming consent, approval, or final submission checkpoints (for final submission actions), destructive or live infra actions, or fields that hold a secret, credential, token, or private key, where a mistaken name raises operational risk
- deciding whether to keep a deployed resource identifier while changing the product or documentation vocabulary

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
- whether the name marks a consent, approval, or final-submission gate, a destructive live infra action, or secret handling, and what risk a wrong name carries
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
- explicit scope, approval, and risk language for names tied to secret handling, final-submission paths, and destructive or live infra actions

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
- Push back when a requested rename creates churn without improving meaning.
- Keep public contracts stable unless the name is actively misleading or harmful.
- For names tied to secret, credential, token, and private key domains, avoid exposing scope changes that can break safety policy, and keep migration plans explicit.
- If the safest answer is to keep the current public contract and only improve internal labels, say so clearly.

## Workflow Coordination

This skill owns its domain work. Use `vincent-workflow` for durable decisions, blockers, resume handoffs, known issues, commit/push/cleanup obligations, or project-local follow-up state. Use `codex-closeout` for final chat delivery, `codex-html-report` for durable reader-facing proof, and `second-brain-context` only for cross-repo or future local-brain retrieval.
