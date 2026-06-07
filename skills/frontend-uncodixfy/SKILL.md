---
name: frontend-uncodixfy
description: Redesign or polish frontend UI so it feels intentional, product-specific, accessible, responsive, and less generic. Use after frontend-review findings or when the user wants a UI anti-slop pass, dashboard cleanup, layout refinement, visual hierarchy correction, or implementation polish that avoids templated AI-generated patterns.
metadata:
  short-description: Frontend anti-slop redesign
---

# Frontend Uncodixfy

Use this skill for design correction and implementation polish. It turns frontend-review findings into a better interface.

Keep the skill ID for compatibility, but treat the working name as frontend anti-slop: remove generic AI UI habits, preserve useful product intent, and make the screen work better.

## When To Use

Use this skill when:
- `frontend-review` found layout, hierarchy, or visual-system problems that need design correction
- the user asks for redesign, polish, cleanup, less templated UI, or less AI-generated UI
- an app has dashboard filler, weak hierarchy, overdecorated cards, awkward spacing, or generic SaaS styling
- a page needs implementation changes, not only a critique

Do not use it to fight a coherent design system. If the app already has a visual language, improve that language. Do not replace it with a personal taste layer.

## How It Works With Frontend Review

Default paired flow:

1. Start from `frontend-review` findings when available.
2. Fix the highest-impact UX and layout issue first.
3. Remove generic visual filler only when it does not carry product meaning.
4. Verify the revised screen with the same evidence standard used by `frontend-review`.
5. Return concise proof: what changed, what was checked, and what risk remains.

If no review exists, run a quick review pass first: task, hierarchy, layout, accessibility, performance, visual system.

## Modes

- `audit`: identify anti-slop problems and propose a direction without editing.
- `redesign`: produce a concrete design direction or implementation plan.
- `implement`: edit files and verify the rendered result when possible.
- `verify`: inspect the result after changes and confirm whether the screen improved.

Default to `implement` when the user clearly asks you to update the UI.

## Core Standard

Good frontend polish is not decoration. It should improve:

- task completion
- information hierarchy
- accessibility and interaction comfort
- responsive behavior
- product-specific visual identity
- maintainability inside the existing codebase

## Anti-Slop Rules

Challenge these patterns:
- decorative hero blocks inside operational screens
- metric-card grids used before the page has a task model
- cards inside cards without a functional reason
- fake charts, fake activity, fake insights, and placeholder widgets
- labels that describe mood instead of product meaning
- oversized radii, pill overload, glow, blur haze, glass panels, and gradient shells used as taste substitutes
- one-note palettes, especially default blue-purple SaaS styling, unless the product already owns that palette
- excess whitespace that hides weak structure
- hover transforms and animation that do not clarify interaction
- repeated panels with identical visual weight but different importance
- copy that explains how polished the UI is instead of helping the user act

Do not apply bans mechanically. The test is whether the choice helps the product, not whether it appears on a list.

## Preferred Patterns

Prefer:
- clear page structure based on user tasks
- restrained headers with useful actions and state
- stable grids, tables, forms, tabs, and lists
- cards only for repeated objects, modals, or genuinely framed tools
- predictable spacing with an existing token scale where possible
- accessible color contrast and non-color state indicators
- component-level responsive behavior using intrinsic layout or container queries where they fit
- real data, real product state, or honest empty states
- fewer surfaces with stronger hierarchy

## Implementation Rules

When editing code:

1. Read existing components, styles, tokens, and layout conventions.
2. Preserve the framework and design system unless there is a clear reason not to.
3. Fix structure before color.
4. Use existing components before adding new primitives.
5. Add an abstraction only when repeated layout or visual logic needs one.
6. Keep copy short and task-specific.
7. Define stable dimensions for fixed-format UI like boards, charts, cards, counters, and toolbars.
8. Verify desktop and mobile. Include screenshots or browser observations when possible.
9. Check accessibility basics after changes.
10. If interaction feels slow or heavy, route to `react-performance-review` or `webapp-testing`.

## Output

For audit or redesign mode:
- state the main UI failure
- state the design direction
- list the smallest useful change set
- name what should be verified

For implementation mode:
- summarize the changed user experience
- name the main files changed
- report rendered checks, viewports, and accessibility or interaction checks
- state remaining risk only if real

## Reference

Use `references/Uncodixfy.md` as an anti-pattern catalogue and design-correction checklist.
