# Design System Maintenance Checklist

## Tokens

- color, spacing, typography, radius, motion tokens are explicit
- product code is not bypassing tokens casually
- token naming reflects semantics, not one-off implementation details

## Primitives

- buttons, inputs, layout primitives, and feedback components are trustworthy
- primitive APIs stay small and composable
- common accessibility behavior is centralized

## Variants

- each variant has a real semantic reason to exist
- product quirks are not encoded as first-class system variants
- redundant variants are candidates for removal

## Consumer ergonomics

- examples show the preferred path
- deprecations include migration guidance
- docs cover when not to use a component, not just how

## Anti-patterns

- adding wrappers endlessly instead of fixing primitives
- exposing every CSS knob in the component API
- treating screenshots as the system instead of code and tokens
