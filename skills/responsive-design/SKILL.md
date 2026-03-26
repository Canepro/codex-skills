---
name: responsive-design
description: Build or fix responsive frontend layouts across mobile, tablet, and desktop using mobile-first breakpoints, fluid spacing and typography, container queries, adaptive navigation, and responsive data displays. Use when the user asks to improve small-screen behavior, fix breakpoints, make a page mobile friendly, or design layouts that adapt cleanly at different sizes.
metadata:
  short-description: Build and fix responsive layouts
---

# Responsive Design

Use this skill when the main problem is layout adaptation across screen sizes and device contexts.

## Use when

- a page looks broken or cramped on mobile
- breakpoints are inconsistent or too viewport-centric
- tables, forms, or dashboards do not adapt well on smaller screens
- spacing or typography feels rigid across devices
- the user wants a mobile-first or container-query-based layout pass

## Do not use when

- the main request is a visual redesign or taste upgrade. Use `frontend-uncodixfy`.
- the main request is browser automation or regression checking. Use `webapp-testing`.
- the page logic is broken independently of layout behavior.

## Workflow

### 1. Audit the current layout model

Identify:
- current breakpoints and whether they are mobile-first
- layout primitives in use: block flow, flex, grid, subgrid
- components that depend too heavily on viewport width
- failure points: overflow, awkward wrapping, broken alignment, unusable controls

### 2. Pick the right responsiveness strategy

Choose deliberately:
- **mobile-first media queries** for page-level structure
- **container queries** for reusable components that appear in multiple contexts
- **fluid scales** for typography and spacing that should grow smoothly
- **content-based breakpoints** when the layout breaks before a standard device width

Do not add more breakpoints than the content actually needs.

### 3. Fix structure before polish

Prioritize:
- readable content width
- predictable grid collapse behavior
- stable control sizing
- touch-friendly spacing where interaction density allows
- clear order of importance on smaller screens

### 4. Handle high-risk UI patterns explicitly

Give extra attention to:
- tables and dense data views
- sidebars and filter panels
- navigation bars and tab rows
- multi-column forms
- dashboards with card grids of uneven importance

Use transformation patterns intentionally rather than just stacking everything.

### 5. Verify key widths

At minimum, verify:
- narrow mobile
- large mobile / small tablet
- tablet
- laptop
- wide desktop

Check both visual layout and interaction comfort.

## Output expectations

- Explain the chosen responsive strategy, not just the CSS edits.
- Call out any component that should use container queries rather than global breakpoints.
- Preserve the established design system unless the user explicitly asks for a visual redesign.
- When a layout remains intentionally dense, explain why.

## References

- Read `references/patterns.md` for breakpoint strategy, container-query guidance, and common failure modes.
- Pair with `frontend-uncodixfy` when the page also needs visual direction.
- Pair with `webapp-testing` when the user wants regression confidence after the layout pass.
