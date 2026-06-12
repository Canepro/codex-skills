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

- the main request is a visual redesign or taste upgrade. Use `frontend-anti-slop`.
- the main request is browser automation or regression checking. Use `webapp-testing`.
- the page logic is broken independently of layout behavior.

## Workflow

### 1. Audit the current layout model

Identify:
- current breakpoints and whether they are mobile-first
- **layout stability dimensions**, including width, height, and reserved space for late-loading content
- layout primitives in use: block flow, flex, grid, subgrid
- components that depend too heavily on viewport width
- failure points: overflow, awkward wrapping, broken alignment, unusable controls

### 2. Pick the right responsiveness strategy

Choose deliberately:
- **mobile-first media queries** for page-level structure
- **container queries** for reusable components that appear in multiple contexts
- **fluid scales** for typography and spacing that should grow smoothly
- **content-based breakpoints** when the layout breaks before a standard device width
- **safe-area-aware viewport sizing** for mobile chrome and notch behavior

Do not add more breakpoints than the content actually needs.

### 2a. Modern viewport units and safe areas

Use modern viewport units where chrome and toolbars shift:
- prefer dynamic viewport units such as `dvh` for full-height regions that must follow browser chrome
- use `svh` for stable small-viewport calculations in constrained contexts
- apply `env(safe-area-inset-top)`, `env(safe-area-inset-right)`, `env(safe-area-inset-bottom)`, and `env(safe-area-inset-left)` for edge padding
- avoid hardcoded `100vh` on elements that need full-height behavior

### 2b. Keep sensitive UI behavior unchanged

Responsive layout changes must not mutate:
- consent flow order, wording, and submission state
- secret reveal, secret copy actions, masking, and ownership handling
- approval buttons, step gates, and legal acknowledgment checkpoints

### 2c. Container query specifics

Use container queries for component-level adaptation:
- set `container-type: inline-size` on the component wrapper that owns its own layout
- define local rules with `@container (min-width: 40cqi)` and `@container (max-width: 30cqi)`
- use `cqi` units for spacing or gaps so sizing follows the container, not the viewport
- keep container breakpoints separate from global page breakpoints unless needed

### 3. Fix structure before polish

Prioritize:
- readable content width
- predictable grid collapse behavior
- stable control sizing
- touch-friendly spacing where interaction density allows
- explicit touch target minimums: set `min-width: 44px` and `min-height: 44px` for interactive elements on touch screens
- keep a clear order of importance on smaller screens

### 4. Handle high-risk UI patterns explicitly

Give extra attention to:
- tables and dense data views
- sidebars and filter panels
- navigation bars and tab rows
- multi-column forms
- dashboards with card grids of uneven importance

Use transformation patterns intentionally rather than just stacking everything.

For long content and dense tables on narrow screens, enforce:
- `overflow-x: auto` on a dedicated scroll wrapper, such as `.table-shell`, so wide rows can scroll instead of forcing page overflow
- `overflow-wrap: break-word;` for long unbroken strings in content cells and labels
- `word-break: break-word;` for dense text blocks, IDs, tokens, and code-like values
- `max-width: 100%` on tables, preformatted blocks, and long text containers to keep overflow controlled

### 4a. Respect user motion and input preferences

- wrap decorative transitions and animations behind `prefers-reduced-motion`
- tailor hit targets and spacing for `pointer: coarse` inputs
- provide non-hover interaction paths and test `hover: hover` alternatives
- align theme-sensitive behavior with `prefers-color-scheme` so layouts stay clear in either mode

### 5. Verify key widths

At minimum, verify:
- narrow mobile
- large mobile / small tablet
- tablet
- laptop
- wide desktop

Check both visual layout and interaction comfort.

Also verify:
- layout stability and dimensions across orientation and width shifts
- motion and input preference behavior
- consent, secret, and approval behavior remains unchanged

## Output expectations

- Explain the chosen responsive strategy, not just the CSS edits.
- Call out any component that should use container queries rather than global breakpoints.
- Preserve the established design system unless the user explicitly asks for a visual redesign.
- When a layout remains intentionally dense, explain why.

## References

- Read `references/patterns.md` for breakpoint strategy, container-query guidance, and common failure modes.
- Pair with `frontend-anti-slop` when the page also needs visual direction.
- Pair with `webapp-testing` when the user wants regression confidence after the layout pass.

## Workflow Coordination

This skill owns its domain work. Use `vincent-workflow` for durable decisions, blockers, resume handoffs, known issues, commit/push/cleanup obligations, or project-local follow-up state. Use `codex-closeout` for final chat delivery, `codex-html-report` for durable reader-facing proof, and `second-brain-context` only for cross-repo or future local-brain retrieval.
