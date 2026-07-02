---
name: design-system-maintenance
description: Maintain and evolve a design system or component library by managing tokens, primitives, variants, documentation, deprecations, and consumer consistency. Use when the user wants to reduce UI drift, clean up component APIs, review token usage, or make a shared design system easier to extend without breaking product teams.
metadata:
  short-description: Maintain design systems and component APIs
---

# Design System Maintenance

Use this skill when the problem is system coherence over time, not just one screen.

## Use when

- shared components are drifting across products
- token usage is inconsistent
- component APIs are bloated or confusing
- variants keep multiplying without discipline
- the team needs a cleaner path for deprecation or extension

## Do not use when

- the request is a one-off screen review. Use `frontend-anti-slop` in audit mode.
- the request is a visual redesign of a specific page. Use `frontend-anti-slop`.
- the main issue is responsive behavior on one screen. Use the installed vendor frontend testing/debugging skill when available.
- the request is shadcn-specific component, registry, preset, CLI, or `components.json` work. Use the installed `build-web-apps:shadcn` vendor plugin when available.
- the request is product-design prototyping, image-to-code, URL-to-code, or design-vs-implementation QA. Use the installed Product Design vendor plugin when available.

## Routing

If the request mixes one-off screen polish and systemic design drift, split
the work: let the screen-review route (`frontend-anti-slop`) handle the
isolated defect, then prioritize the systemic design-system pattern here.

## Workflow

### 1. Map the system surface

Identify:
- tokens
- primitives
- composite components
- product-specific wrappers
- docs or usage examples
- points of drift between teams

### 2. Find the highest-cost inconsistency

Look for:
- duplicate components with weak differences
- variants that encode product quirks
- styling escapes that bypass tokens
- missing primitives that force reinvention
- component APIs that expose too much internal complexity

Forbid local styling or behavior overrides that bypass the design system. Any
approved exception must route through tokens, documented variants, or a named
extension point so the exception can be audited and removed later.

### 3. Choose the right level to fix

Decide whether the fix belongs in:
- tokens
- primitive components
- composite components
- documentation and examples
- deprecation policy

Do not patch every consumer individually when the problem is systemic.

### 4. Preserve a stable consumer path

When changing the system:
- define migration strategy
- avoid needless breaking changes
- define release/versioning intent (major/minor/patch) before merge
- add consumer-facing release notes and a changelog entry at the project changelog path, commonly `CHANGELOG.md`
- document deprecations clearly
- set a deprecation window with explicit sunset criteria
- keep a rollback plan for consumers that cannot migrate in time
- provide examples of the preferred pattern
- provide consumer migration aids for breaking API changes, such as a codemod,
  compatibility shim, or before/after examples for the affected component API

### 5. Validate shared component publishing

Before publishing shared tokens, primitives, or component changes, when Storybook or an equivalent visual regression setup exists in the repo:
- run visual regression checks with Storybook
- capture or update snapshot baselines for key interaction state variants (hover, focus, active, disabled, loading, error)
- require approval of visual diffs before merge when snapshots or interaction states change

If the repo has no Storybook or equivalent visual regression setup, do not block the publish on this step; tell the user the gap exists and recommend adding coverage.

## Guidance

- Prefer deeper primitives with smaller APIs.
- Add a variant only when the design language truly needs it.
- Remove weak abstractions rather than preserving them for sentiment.
- Treat docs and examples as part of the system, not optional garnish.

## Tooling: DESIGN.md

If the project keeps (or could keep) its design system in a `DESIGN.md` file per the [DESIGN.md spec](https://github.com/google-labs-code/design.md), use it as the single source of truth. The format pairs machine-readable design tokens (YAML front matter) with prose rationale, so agents get exact values and the reasons behind them. That makes it useful for step 1 (mapping tokens), step 2 (spotting drift against a canonical token set), and step 4 (durable documentation consumers can follow).

CLI checks worth running:

- `npx @google/design.md lint DESIGN.md` validates against the spec, catches broken token references, and checks WCAG contrast ratios. Output is structured JSON.
- `npx @google/design.md diff DESIGN.md DESIGN-v2.md` detects token-level and prose regressions between two versions. Useful before publishing a system change.
- `npx @google/design.md export --format json-tailwind|css-tailwind|dtcg DESIGN.md` exports tokens to a Tailwind v3 config object, a Tailwind v4 `@theme` CSS block, or W3C DTCG `tokens.json`, keeping code-side tokens generated rather than hand-maintained.

For repositories with CI, make token, primitive, or shared-component changes pass
an automated gate before merge. A useful pre-merge CI gate runs the lint/diff,
visual regression checks (Storybook snapshot + interaction-state suites), and
project-equivalent checks, and fails when generated tokens, docs, examples,
release notes, or changelog entries are out of sync.

## References

- Read `references/maintenance-checklist.md` for a working maintenance checklist.
- [DESIGN.md spec and CLI](https://github.com/google-labs-code/design.md) (Google Labs): format for describing a design system to coding agents.

## Workflow Coordination

This skill owns design-system token, component, and deprecation work. It does not own general workflow state.

Use `vincent-workflow` for durable decisions, blockers, resume handoffs, known issues, commit/push/cleanup obligations, or project-local follow-up state.
Use `codex-closeout` for final chat delivery.
Use `codex-html-report` for durable reader-facing proof.
Use `second-brain-context` only when the lesson should survive across repos, agents, or future local-brain retrieval.
