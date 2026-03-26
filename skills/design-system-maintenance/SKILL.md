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

- the request is a one-off screen review. Use `frontend-review`.
- the request is a visual redesign of a specific page. Use `frontend-uncodixfy`.
- the main issue is responsive behavior on one screen. Use `responsive-design`.

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
- document deprecations clearly
- provide examples of the preferred pattern

## Guidance

- Prefer deeper primitives with smaller APIs.
- Add a variant only when the design language truly needs it.
- Remove weak abstractions rather than preserving them for sentiment.
- Treat docs and examples as part of the system, not optional garnish.

## References

- Read `references/maintenance-checklist.md` for a working maintenance checklist.
