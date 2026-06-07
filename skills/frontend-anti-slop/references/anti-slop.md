# Frontend Anti-Slop Reference

Use this reference when a UI feels generic, overdecorated, or model-generated. It is a catalogue of patterns to challenge, not a rigid style guide.

## Core Test

Ask:

- What is the user trying to decide or do here?
- Does the layout make that easier?
- Does each visual surface carry product meaning?
- Would this still work with real data, long labels, empty states, errors, and mobile width?
- Does the existing design system already have a better answer?

If the UI choice cannot answer those questions, remove or simplify it.

## Common AI UI Failure Modes

### Decorative Structure

- hero sections inside operational screens
- floating shells around sidebars or page content
- cards inside cards
- right rails that repeat summary content
- metric grids without a task model
- fake charts used to fill space
- activity feeds without actionable content
- empty panels kept for symmetry

### Visual Noise

- glows, blur haze, glass panels, dramatic shadows, and gradient borders used as default styling
- pill-shaped controls repeated across every control type
- oversized radii on cards, buttons, panels, and inputs at the same time
- decorative badges on ordinary labels
- icon backgrounds on every small action
- hover movement that shifts layout or draws attention without adding clarity

### Weak Information Hierarchy

- every panel has equal weight
- headings describe mood instead of function
- secondary copy explains obvious UI behavior
- primary actions are visually quieter than decorative status
- data labels and values are hard to compare
- charts, counters, and tables do not share a clear reading order

### Generic Product Voice

- "command center", "live pulse", "operational clarity", "unlock insights", or similar mood labels without product meaning
- section notes that explain the UI instead of the domain
- empty-state copy that reassures instead of giving the next action
- onboarding copy that promises value before the UI proves it

## Better Defaults

- Use layout to expose the workflow, not to show design effort.
- Prefer one strong content area over many equal panels.
- Use tables and lists for comparison. Use cards for repeated objects with meaningful boundaries.
- Keep headings functional: object, state, action, or decision.
- Put controls near the state they affect.
- Make empty states honest: what happened, why, what to do next.
- Make destructive or sensitive actions visually and spatially distinct.
- Use color to encode state or hierarchy, not to decorate all surfaces.
- Keep animation short, local, and explanatory.

## Modern Layout Guidance

- Use intrinsic layout first: grid, flex, minmax, clamp, aspect-ratio, and sane min/max widths.
- Use container queries when a component must adapt to the space its parent gives it.
- Avoid viewport-only breakpoints for reusable components.
- Give fixed-format UI stable dimensions so labels, hover states, loading states, or data changes do not resize the layout unexpectedly.
- Design overflow intentionally for tables, tabs, filters, and toolbars.
- Test narrow, common laptop, and wide desktop widths before calling the layout done.

## Accessibility And Interaction

- Preserve visible focus and keyboard reachability.
- Keep targets large enough for pointer and touch use.
- Use text or structure as well as color for state.
- Check contrast before treating a palette as acceptable.
- Keep forms predictable: clear labels, local errors, and specific recovery actions.
- Avoid heavy animations, rerenders, and client work on frequent interactions.

## Palette Guidance

Do not ban a color family globally. Judge whether the palette fits the product and has enough contrast.

Challenge:
- default blue-purple SaaS gradients
- dark navy dashboards with cyan accents used without product reason
- beige or cream themes used as fake warmth
- one-accent UIs where every element competes
- muted text that looks refined but fails readability

Prefer:
- product-owned tokens
- restrained accent use
- clear state colors
- enough neutral contrast for long sessions
- palettes that work in real lighting and on lower-quality displays

## Implementation Checklist

Before finishing:

- The primary task is clearer than before.
- The layout works at desktop and mobile widths.
- No meaningful text overlaps or clips.
- Dynamic content has a planned layout path.
- Focus, contrast, labels, and target size have been checked.
- There is no fake data or filler UI unless explicitly marked as mock content.
- The change fits the existing component system.
