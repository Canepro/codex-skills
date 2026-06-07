---
name: frontend-review
description: Review frontend screens, PRs, or UI implementations for task flow, information hierarchy, accessibility, responsiveness, interaction performance, design-system fit, and implementation quality. Use when the user wants a pre-ship UI audit, frontend code review, UX critique, or prioritized findings before redesign or verification work.
metadata:
  short-description: Evidence-first frontend audit
---

# Frontend Review

Use this skill for diagnosis and prioritization. It should produce evidence-backed findings and decide whether `frontend-anti-slop`, `responsive-design`, `webapp-testing`, `react-performance-review`, or `design-system-maintenance` should take the next step.

Do not redesign by default. If a fix is obvious and low-risk, state it, but keep the review focused on what is wrong, why it matters, and what should happen next.

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
- name the exact element, state, viewport, or file behind each finding

If rendered evidence is unavailable, say that clearly and limit confidence.

## Review Lenses

Review in this order:

1. Task flow and decision clarity
2. Information hierarchy and content density
3. Layout structure, responsiveness, and overflow handling
4. Accessibility basics, including WCAG 2.2 practical checks
5. Interaction responsiveness and perceived performance
6. Visual-system consistency and design-system fit
7. Implementation maintainability

## Modern Frontend Checks

- Accessibility: visible focus, keyboard reachability, target size, labels, contrast, no color-only state, and no unnecessary cognitive load in authentication or forms.
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

1. Findings, ordered by severity, with file or screen references when available.
2. Evidence checked, including viewports or screenshots if used.
3. Recommended next step: fix directly, use `frontend-anti-slop`, use another specialist skill, or no change.

Avoid long nit lists. Prefer fewer findings that change the outcome.

## Reference

Read `references/review-checklist.md` when the review needs a fuller checklist.
