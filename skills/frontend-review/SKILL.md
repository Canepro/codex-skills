---
name: frontend-review
description: Review frontend screens or code for UX clarity, information hierarchy, accessibility basics, responsiveness, visual consistency, and implementation quality. Use when the user wants a UI audit, design critique, code review of a frontend change, or prioritized findings about what should improve before shipping.
metadata:
  short-description: Audit frontend UX and implementation
---

# Frontend Review

Use this skill for review and diagnosis, not for full redesign by default.

## Use when

- the user asks for a frontend review or UI audit
- a pull request needs frontend-focused findings
- a screen feels off but the user does not yet know why
- the goal is to prioritize issues before rewriting anything

## Do not use when

- the user already wants an aesthetic redesign. Use `frontend-uncodixfy`.
- the main problem is responsive behavior. Use `responsive-design`.
- the main task is browser automation or regression execution. Use `webapp-testing`.

## Review lenses

Review in this order:
1. task flow and information hierarchy
2. layout structure and responsiveness
3. accessibility basics
4. visual consistency and design-system adherence
5. implementation quality and maintainability

## Workflow

### 1. Inspect the actual surface

Prefer evidence:
- read the relevant components and styles
- run the app or inspect screenshots when available
- identify the user task the screen is supposed to support

### 2. Find the highest-cost problems first

Prioritize issues that:
- block task completion
- create confusion about what to do next
- hide important actions or state
- break on common screen sizes
- create obvious accessibility problems

### 3. Report findings like a code review

Default output:
- findings first
- ordered by severity
- with concrete rationale
- with file references when code is available

Do not jump straight to polish advice if there are structural problems.

### 4. Separate categories cleanly

Distinguish:
- user-flow problems
- layout problems
- accessibility problems
- visual inconsistency
- implementation debt

This prevents “make it prettier” from hiding the real issue.

### 5. Recommend the next skill when appropriate

Escalate to:
- `frontend-uncodixfy` for redesign or visual direction
- `responsive-design` for breakpoint and adaptive-layout work
- `webapp-testing` for browser-based verification after changes

## Output expectations

- Keep the review concrete and evidence-backed.
- Name the specific UI element or screen state that fails.
- Prefer fewer, sharper findings over a long list of nits.

## References

- Read `references/review-checklist.md` for the working review checklist.
