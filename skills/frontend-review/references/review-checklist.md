# Frontend Review Checklist

Use this as a working checklist, not a report template.

## Task Flow

- Is the primary task clear within the first scan?
- Is the primary action visible, specific, and placed near the relevant context?
- Does the screen make current state, empty state, loading state, success, and failure clear?
- Are destructive, billing, privacy, or irreversible actions clearly separated from routine actions?
- Does the page reduce decisions, or does it create extra interpretation work?

## Information Hierarchy

- Does the most important content dominate for a real product reason?
- Are headings, labels, values, and actions visually distinct?
- Does each section add a new decision, fact, or action?
- Can repeated cards, rows, or panels be compared without reading decorative copy?
- Is supporting text useful, or is it explaining the UI instead of improving the UI?

## Layout And Responsiveness

- Does the layout stay intentional at mobile, tablet, laptop, and wide desktop sizes?
- Do key components adapt to their container, not only the viewport?
- Are container queries, intrinsic sizing, grid, flex, min/max constraints, or stable aspect ratios a better fit than fixed breakpoints?
- Do tables, tabs, filters, toolbars, charts, and forms handle wrapping and overflow deliberately?
- Are touch targets comfortable and reachable on small screens?
- Does dynamic content change layout size unexpectedly?

## Accessibility

- Are interactive elements keyboard reachable and focus-visible?
- Are labels programmatic, not only visual?
- Does text and meaningful iconography meet contrast expectations?
- Is important state communicated with text or structure, not color alone?
- Are target sizes and spacing suitable for pointer and touch use?
- Are form errors specific, located near the field, and announced where the framework supports it?
- Does authentication avoid unnecessary memory puzzles or copy/paste blocking?

## Interaction Performance

- Are clicks, typing, filters, menus, and drag actions likely to respond quickly?
- Are expensive renders, hydration, animations, or data refetches tied to frequent interactions?
- Would a slow interaction affect Interaction to Next Paint or perceived control?
- Is loading feedback honest and local to the affected surface?
- Are images, charts, and heavy widgets sized and loaded in a way that avoids layout shift?

## Visual System

- Does the UI follow the existing product system before inventing a new one?
- Are spacing, radii, borders, type scale, shadows, and color roles consistent?
- Are accents used to clarify state or action, not to decorate every surface?
- Are cards, panels, modals, and buttons visually distinct by function?
- Does the palette have enough contrast and enough restraint?

## Implementation Quality

- Are tokens, shared components, and utilities used where expected?
- Are one-off styles justified by product need?
- Is CSS specificity controlled, or are overrides fighting each other?
- Would this component survive new data lengths, translations, permissions, and empty states?
- Is visual behavior covered by tests, stories, screenshots, or at least a clear verification path?
