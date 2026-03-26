# Responsive Design Patterns

## Preferred strategy order

1. Fix document structure and hierarchy.
2. Make the smallest layout work well first.
3. Add only the breakpoints the content needs.
4. Use container queries when a component appears in multiple parent layouts.
5. Use fluid sizing where interpolation is better than hard jumps.

## Choose the right tool

- Use **media queries** for page-level layout changes.
- Use **container queries** for cards, panels, nav items, and reusable modules.
- Use **CSS Grid** when two-dimensional placement matters.
- Use **Flexbox** when distribution along one axis is the real problem.
- Use **`clamp()`** for fluid typography or spacing with clear lower and upper bounds.

## Common failure modes

- adding too many breakpoints without a content-based reason
- making desktop the source of truth and compressing it downward
- forcing tables to stay tabular when cards or priority columns are better
- collapsing sidebars without rethinking task flow
- preserving decorative whitespace that destroys mobile usability
- shrinking tap targets below comfortable interaction size

## Data-heavy UI options

When a table does not fit:
- keep the table and add horizontal scroll only if comparison across columns is the core task
- hide lower-priority columns only when the task still makes sense
- convert rows to cards only when scanning single records matters more than cross-row comparison

## Quick checklist

- No horizontal overflow at intended widths
- Navigation remains understandable
- Forms preserve clear label-to-input association
- Important actions stay visible without awkward scrolling
- Dense screens remain readable, not merely smaller
