---
name: frontend-anti-slop
description: Review, redesign, or polish frontend UI so it feels intentional, product-specific, accessible, responsive, and less generic. Use when the user wants a frontend review, UI audit, UX critique, frontend PR review, severity-ranked findings, a UI anti-slop pass, dashboard cleanup, layout refinement, visual hierarchy correction, or implementation polish that avoids templated AI-generated patterns.
metadata:
  short-description: Frontend review and anti-slop redesign
---

# Frontend Anti-Slop

Use this skill for frontend diagnosis, design correction, and implementation polish. It audits screens for evidence-backed findings, turns those findings into a better interface, removes generic AI UI habits, and preserves useful product intent.

## Why This Skill Exists

Coding agents default to templated SaaS UI: hero blocks on dashboards, metric grids without a task, mixed radii, glassmorphism, blue-purple gradients, welcome-back copy. That is the model reaching for its training distribution. The rules below are forcing functions, not taste. Follow them and the output stops looking generated.

## When To Use

Use this skill when:
- the user asks for a frontend review, UI audit, UX critique, or frontend PR review
- a screen feels off and the failure mode is not yet clear
- the user needs a severity-ranked list of findings before implementation
- the user asks for redesign, polish, cleanup, less templated UI, or less AI-generated UI
- an app has dashboard filler, weak hierarchy, overdecorated cards, awkward spacing, or generic SaaS styling
- a page needs implementation changes, not only a critique

Do not use it to fight a coherent design system. If the app already has a visual language, improve that language. Do not replace it with a personal taste layer.

## Routing

Hand off before you start when one of these is the real task:
- copy or microcopy in the change set: also run `anti-ai-writing`
- breakpoint repair only: `responsive-design`
- end-to-end browser proof of flows: `webapp-testing`
- render, hydration, or bundle performance: `react-performance-review`
- component library governance: `design-system-maintenance`

## Audit First, Then Fix

1. Run the audit pass first when no findings exist yet: task, hierarchy, layout, accessibility, performance, visual system.
2. Fix the highest-impact UX and layout issue first.
3. Remove generic visual filler only when it does not carry product meaning.
4. Verify the revised screen with the Verification Protocol below.
5. Return concise proof: what changed, what was checked, and what risk remains.

## Modes

- `audit`: produce severity-ranked, evidence-backed findings without editing. Use for review, UX critique, and pre-ship risk checks.
- `redesign`: produce a concrete design direction or implementation plan.
- `implement`: edit files and verify the rendered result when possible.
- `verify`: inspect the result after changes and confirm whether the screen improved.

Default to `implement` when the user clearly asks you to update the UI. Default to `audit` when the user asks for a review, critique, or findings.

## Audit Mode

Review in this order:

1. Task flow and decision clarity
2. Information hierarchy and content density
3. Layout structure, responsiveness, and overflow handling
4. Accessibility basics, including WCAG 2.2 practical checks: keyboard navigation, focus order, screen reader cues, color contrast, skip links
5. Interaction responsiveness and perceived performance
6. Visual-system consistency and design-system fit
7. Implementation maintainability

Prefer direct evidence over taste claims:
- read relevant components, routes, styles, tokens, and design-system docs
- run the app or inspect screenshots when available
- name the exact element, state, viewport, and `file:line` behind each finding
- include a screenshot path and concise reproduction steps for each visual issue
- if rendered evidence is unavailable, say so clearly and limit confidence

Finding severity:
- P0: blocks task completion, hides critical state, prevents access, or risks wrong user action.
- P1: causes likely confusion, broken mobile behavior, inaccessible controls, obvious visual inconsistency, or poor interaction response.
- P2: polish, maintainability, minor hierarchy, copy, spacing, or consistency issues.

Audit output:
1. Primary user task, in one sentence. Every finding is judged against it.
2. Findings ordered by severity: what is broken and why, user impact, minimal remediation, evidence (`file:line`, screenshot path, reproduction steps).
3. Evidence checked: viewports, zoom levels, content states, how each finding was validated.
4. Triage signal: ship-blocker vs follow-up.
5. Recommended next step: fix directly here in `implement` mode, route to a specialist skill, or no change.
6. Conclude with a `ready to ship` decision only after ship-blockers are cleared.

Avoid long nit lists. Prefer fewer findings that change the outcome. Do not redesign by default in audit mode; if a fix is obvious and low-risk, state it.

## Pre-Design Discovery

Required before any edit. Write these down. If any are unknown, ask the user or read the repo before designing.

- Primary user task on this screen, in one sentence.
- Existing spacing scale (the numbers actually used in the codebase).
- Existing radii, type ramp, and primary color tokens.
- Component primitives already available (Button, Card, Table, etc.).
- Layout primitives or container conventions (Stack, Grid, Page, etc.).

Skipping this step is the most common cause of slop: parallel tokens, reinvented primitives, off-system spacing.

If the repo has a `DESIGN.md` file per the [DESIGN.md spec](https://github.com/google-labs-code/design.md), treat it as the authority for tokens, palette, and type ramp. Read it before inventing values, and validate edits against it with `npx @google/design.md lint DESIGN.md`.

## Design Ladder

Make decisions in this order. Most slop comes from skipping ahead.

1. Structure: what blocks the page has, in what reading order.
2. Hierarchy: which block dominates, which support it, which are background.
3. State colors: success, warning, danger, info, used only where state changes meaning.
4. Density: where the page breathes and where it tightens, by design not accident.
5. Motion: short, local, explanatory.
6. Surface effects: shadows, borders, gradients. Last, and only when they earn the cost.

## Subtraction First

Before adding any element, list 2 to 3 elements to delete, merge, or move. Name each one and the reason. If nothing can be removed, the layout is probably already too sparse and the real problem is hierarchy, not content.

This is the single largest behavior gap between agents that produce good UI and agents that produce generic UI.

## Anti-Slop Rules

Severity is inline. P0 should always be fixed. P1 should be fixed unless there is a written product reason. P2 is judgment.

### Structure

- P0: fake charts, fake activity, fake insights, placeholder widgets shipped as real UI
- P0: decorative hero blocks inside operational screens
- P0: cards inside cards without a functional reason
- P0: more than 6 to 8 top-level panels on one screen without a clear primary three. Demote the rest to nav, drill-in pages, or a collapsed appendix.
- P1: metric-card grids used before the page has a task model
- P1: empty panels kept for symmetry
- P1: right rails that repeat summary content shown elsewhere
- P2: repeated panels with identical visual weight but different importance

### Visual

- P0: glassmorphism, blur haze, glow shadows used as default styling on operational screens
- P1: oversized radii, pill overload, and gradient shells used as taste substitutes
- P1: one-note palettes, especially default blue-purple SaaS styling, unless the product already owns that palette
- P1: mixed radii across surfaces of the same role (4px and 16px buttons on the same page)
- P1: icon backgrounds on every small action, or decorative icons on every nav row, KPI corner, and panel head
- P2: decorative badges on ordinary labels

### Copy

- P0: unfilled placeholders (`[Your Name]`, `TODO`, lorem ipsum) shipped in real UI
- P0: emoji-prefixed mood headers ("Welcome back!", "Let's get started", "Your AI insights")
- P1: section headings that describe mood instead of function ("Command Center", "Live Pulse")
- P1: copy that explains how polished the UI is instead of helping the user act
- P1: empty-state copy that reassures instead of giving the next action
- P2: button labels that are nouns or moods ("Continue your journey") instead of verbs ("Save changes")

For any user-visible string you change, run `anti-ai-writing` over it before shipping.

### Interaction

- P1: hover transforms or animation that do not clarify interaction
- P1: layout-shifting hover states
- P2: long transitions on frequent interactions (over 200ms on hover or click)

Do not apply these mechanically. The test is whether the choice helps the product, not whether it appears on a list.

## Preferred Patterns

Prefer:
- clear page structure based on user tasks
- restrained headers with useful actions and state
- stable grids, tables, forms, tabs, and lists
- cards only for repeated objects, modals, or genuinely framed tools
- predictable spacing on the existing token scale
- accessible color contrast and non-color state indicators
- component-level responsive behavior using intrinsic layout or container queries where they fit
- real data, real product state, or honest empty states
- fewer surfaces with stronger hierarchy

## Concrete Defaults

When the existing system gives no answer, start here. These values are conservative and rarely wrong. Override them when the product calls for it.

- Spacing scale: 4, 8, 12, 16, 24, 32, 48. Pick one base unit and stay on it.
- Radius: 4 to 8px for most surfaces. Do not mix scales on the same page. 0px is valid for dense work surfaces.
- Type ramp on operational screens: body 14, label 12 to 13, section heading 16 to 18, page title 20 to 24. Bump higher only on marketing or empty-state surfaces.
- Form control height: 32 to 40px, matched across the form.
- Table row height: 36 to 44px.
- Content max width for prose: roughly 72ch.
- Motion: 150 to 200ms, ease-out, opacity and transform only on frequent interactions.
- Shadow: one elevation level per page when possible. Two is the cap.
- Color: one accent for primary action, one for destructive, plus state colors. No third decorative accent.

See `references/anti-slop.md` for fuller defaults and bad-to-good rewrites of common surfaces.

## Implementation Rules

When editing code:

1. Complete Pre-Design Discovery first.
2. Preserve the framework and design system unless there is a clear reason not to.
3. Fix structure before color.
4. Use existing components before adding new primitives.
5. Add an abstraction only when repeated layout or visual logic needs one.
6. Keep copy short and task-specific. Run `anti-ai-writing` over any strings you change.
7. Define stable dimensions for fixed-format UI like boards, charts, cards, counters, and toolbars.
8. Verify at the viewports listed below.
9. Check accessibility basics after changes.
10. If interaction feels slow or heavy, route to `react-performance-review` or `webapp-testing`.

## Verification Protocol

Replace vague "looks good on mobile" checks with:

- Viewport widths: 360, 768, 1024, 1440. Spot-check 1920 if the layout has a wide variant.
- Browser zoom: 100% and 125%. Text and controls should not clip.
- Content states for each meaningful surface: long string, empty, error, loading.
- Keyboard pass: tab through the primary action, confirm focus is visible at every stop.
- Color and contrast: no color-only state, body text meets WCAG AA against its background.
- Real data, or a clearly labeled mock state.

Capture screenshots or a short rendered description for each viewport when possible.

## Done When

Stop polishing when all of these are true:

- The primary user task is more obvious than before.
- Layout works at 360 and 1440 widths.
- Every copy string changed in this pass has run through `anti-ai-writing`.
- No fake data, no placeholder text, no decorative filler.
- All tokens used exist in the design system, or new tokens were added on purpose.
- Focus, contrast, and target size were checked.
- You can name what was removed, not only what was added.

If you keep iterating past this list, you are adding slop back.

## Output

For audit or redesign mode:
- state the main UI failure
- state the design direction
- list the smallest useful change set
- name what should be verified

For implementation mode:
- summarize the changed user experience
- name the main files changed
- report rendered checks (viewports, zoom, content states) and accessibility checks
- list what was removed in this pass
- state remaining risk only if real

## Reference

Use `references/anti-slop.md` as an anti-pattern catalogue, fuller defaults table, and bad-to-good design library.

Read `references/review-checklist.md` when an audit needs a fuller checklist.
