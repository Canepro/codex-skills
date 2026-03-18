---
name: frontend-uncodixfy
description: Use for frontend UI/UX work when you want a professional, human-designed result that avoids generic AI dashboard patterns, dead space, pill overload, decorative hero blocks, and other low-signal visual filler.
metadata:
  short-description: Frontend anti-slop UI guidance
---

# Frontend Uncodixfy

Use this skill for frontend work where the goal is a professional, intentional UI rather than a generic AI-looking dashboard.

This skill is based on the reference in `references/Uncodixfy.md`, but adapted into practical Codex instructions.

## When To Use

Use this skill when the user asks for any of the following:
- frontend redesign or polish
- dashboard cleanup
- layout refinement
- UX coherence pass
- landing page improvement
- removal of awkward spacing / dead space
- making the UI feel more professional, less templated, or less AI-generated

Do not use it to fight an established design system without reason. If the app already has a coherent visual language, improve that system rather than replacing it.

## Core Goal

Build interfaces that feel deliberate, functional, and human-designed.

The baseline is:
- clear structure
- consistent spacing
- restrained styling
- strong information hierarchy
- minimal decorative copy
- layouts that earn their space

## Hard Rules

Avoid these unless the user explicitly asks for them:
- oversized corner radii
- pill-shaped controls everywhere
- floating glass panels as the default pattern
- hero sections inside internal product screens
- decorative labels, eyebrow text, and faux-premium copy
- metric-card grids as the first instinct
- fake charts or filler widgets
- dead space created just to look expensive
- blue/purple SaaS-default styling without product reason
- excessive gradients, glow, blur haze, or floating-shell effects
- gratuitous hover transforms or flashy motion
- inconsistent alignment logic across panels

## Preferred Patterns

Use these defaults instead:
- straightforward page headers with real hierarchy
- normal cards and panels with restrained borders/radius
- dense but readable layouts
- tabs, forms, tables, and lists that prioritize function over decoration
- stable grid systems with predictable column behavior
- labels that describe product meaning, not mood
- short explanatory copy only where it reduces operator confusion
- calm color systems with clear contrast and minimal accent use

## Layout Guidance

When auditing a screen, check these first:
1. Is there dead space caused by a broken grid or orphaned card?
2. Is a card present because it is useful, or because the layout needed filler?
3. Are sections arranged around operator tasks, or around aesthetic symmetry?
4. Is information hierarchy obvious without decorative microcopy?
5. Is the mobile layout still intentional, not just stacked leftovers?

If a page has obvious empty holes, uneven card heights, or disconnected panels, fix the layout structure before changing colors or typography.

## Typography And Styling

- Keep typography controlled and readable.
- Prefer the app's existing type system if it is coherent.
- If you must introduce or revise typography, avoid default AI-dashboard shortcuts and keep the result restrained.
- Use comments sparingly in code, only where the layout logic is not obvious.

## Implementation Standard

When making frontend changes under this skill:
1. Fix structure before polish.
2. Prefer editing the existing system over adding one-off visual exceptions.
3. Remove weak UI elements instead of decorating them more.
4. Make spacing intentional and consistent.
5. Verify desktop and mobile behavior.
6. Update docs when the user-facing behavior or product framing changes.

## Response Pattern

When using this skill, evaluate and communicate frontend work in this order:
1. layout / IA problems
2. operator-task or UX problems
3. visual-system inconsistencies
4. only then color, motion, and polish

## Reference

The full source reference is kept in `references/Uncodixfy.md`.
Use it as an anti-pattern catalogue, not as a rigid template.
