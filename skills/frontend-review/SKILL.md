---
name: frontend-review
description: Review frontend screens, PRs, or UI implementations for task flow, information hierarchy, accessibility, responsiveness, interaction performance, design-system fit, and implementation quality. Use when the user wants a pre-ship UI audit, frontend code review, UX critique, or prioritized findings before redesign or verification work.
metadata:
  short-description: Evidence-first frontend audit
---

# Frontend Review

Use this skill for diagnosis, bug discovery, and prioritization. It should produce evidence-backed findings about regressions and defects, and then decide whether `frontend-anti-slop`, `responsive-design`, `webapp-testing`, `react-performance-review`, or `design-system-maintenance` should take the next step.

Do not redesign by default. If a fix is obvious and low-risk, state it, but keep the review focused on what is wrong, why it matters, and what should happen next.

## Why This Skill Exists

Coding agents tend to skim UI for surface polish and miss the failure modes that matter: unclear task, weak hierarchy, broken responsive behavior, inaccessible state, generic SaaS habits dressed up as design. This skill forces a structured pass against those lenses and routes the next step to the right specialist instead of redesigning on instinct.

## Routing

Pick a different skill if the request is really one of these:
- redesign or polish: `frontend-anti-slop`
- breakpoint repair only: `responsive-design`
- end-to-end browser proof: `webapp-testing`
- render, hydration, or bundle performance: `react-performance-review`
- component library governance: `design-system-maintenance`
- copy or microcopy: `anti-ai-writing`

## When To Use

Use this skill when:
- the user asks for a frontend review, UI audit, UX critique, or frontend PR review
- a screen feels off and the failure mode is not yet clear
- the user needs a severity-ranked list before implementation
- a UI change needs pre-ship risk review
- visual polish, accessibility, responsiveness, or interaction quality may be involved

Do not use it as the primary skill when:
- the user asks to redesign or polish the UI. Use `frontend-anti-slop`, then return here for audit.
- the main request is only breakpoint repair. Use `responsive-design`.
- the main request is end-to-end browser regression proof. Use `webapp-testing`.
- the main request is React render, hydration, or bundle performance. Use `react-performance-review`.
- the main request is component library governance. Use `design-system-maintenance`.

## Paired Workflow

`frontend-review` and `frontend-anti-slop` should work together:

1. Use `frontend-review` first when the problem is unclear or the user wants findings.
2. Use `frontend-anti-slop` next when findings show visual slop, weak hierarchy, generic dashboard patterns, or a need for redesign.
3. Return to `frontend-review` after changes to confirm the original findings are resolved.
4. Use `webapp-testing` for browser proof when flows or rendered states matter.

## Evidence Standard

Prefer direct evidence over taste claims:
- read relevant components, routes, styles, tokens, and design-system docs
- run the app or inspect screenshots when available
- capture or inspect at least desktop and mobile states for meaningful UI work
- identify the primary user task and expected outcome
- name the exact element, state, viewport, and `file:line` behind each finding
- include screenshot path for each visual issue and concise reproduction steps that recreate it

If rendered evidence is unavailable, say that clearly and limit confidence.

When you do have rendered evidence, check at concrete viewports and content states rather than "desktop and mobile":

- Widths: 360, 768, 1024, 1440. Add 1920 only when a wide variant exists.
- Browser zoom: 100% and 125%.
- Content states per meaningful surface: long string, empty, error, loading.
- Keyboard pass on the primary action with focus visible at every stop.

## Review Lenses

Review in this order:

1. Task flow and decision clarity
2. Information hierarchy and content density
3. Layout structure, responsiveness, and overflow handling
4. Accessibility basics, including WCAG 2.2 practical checks with explicit tests for keyboard navigation, focus order, screen reader cues, color contrast, and skip link behavior
5. Interaction responsiveness and perceived performance
6. Visual-system consistency and design-system fit
7. Implementation maintainability

## Modern Frontend Checks

- Accessibility: keyboard navigation and reachability, focus order, visible focus, skip links, labels, target size, screen reader labeling and announcements, color contrast, no color-only state, and no unnecessary cognitive load in authentication or forms.
- Responsiveness: component-level behavior, not only viewport breakpoints. Prefer intrinsic layout, container queries, stable dimensions, and intentional overflow.
- Performance as UX: flag interactions likely to hurt responsiveness, excessive client work, layout shift, heavy animation, expensive hydration, or blocked input.
- CSS architecture: watch for specificity fights, duplicated one-off styles, missing tokens, uncontrolled cascade, and component styles that cannot scale.
- Design systems: preserve a coherent existing system. Do not suggest a new aesthetic when a token or component correction solves the issue.

## Severity

Use severity labels when useful:

- P0: blocks task completion, hides critical state, prevents access, or risks wrong user action.
- P1: causes likely confusion, broken mobile behavior, inaccessible controls, obvious visual inconsistency, or poor interaction response.
- P2: polish, maintainability, minor hierarchy, copy, spacing, or consistency issues.

Findings should lead the response. Keep summaries secondary.

## Output

Default output:

1. Primary user task, in one sentence. This is the first line of the review and the anchor every finding is judged against.
2. Findings, ordered by severity, with this schema:
   - bug: what is broken and why
   - user impact: who is affected and the concrete outcome
   - user impact: user outcome and task risk
   - minimal remediation: smallest safe fix that closes the issue
   - evidence: `file:line`, screenshot path, and reproducible steps
3. Evidence checked, including viewports, zoom levels, content states, and how each finding was validated.
4. Triage signal:
   - ship-blocker: must be fixed before `ready to ship`
   - follow-up: polish or design debt that can be deferred
5. Recommended next step: fix directly, use `frontend-anti-slop`, use another specialist skill, or no change.
6. Conclude with `ready to ship` decision only after ship-blockers are cleared.

Avoid long nit lists. Prefer fewer findings that change the outcome.

## Reference

Read `references/review-checklist.md` when the review needs a fuller checklist.
