# Reference

## Dependency Categories

When evaluating a candidate for architectural deepening, classify its dependencies:

1. In-process
Pure computation or in-memory state with no meaningful I/O boundary. Usually the easiest case to deepen directly.

2. Local-substitutable
Depends on something that has a realistic local stand-in, such as an in-memory database or filesystem substitute. The target boundary can often be tested against that stand-in.

3. Remote but owned
Crosses a boundary to another service you control. Prefer a ports-and-adapters shape so the core behavior can be tested behind a stable interface.

4. True external
Depends on a third-party service you do not control. Mock or fake only at the boundary and keep the dependency behind an injected interface.

## Testing Strategy

Prefer replacing shallow tests with boundary tests once a deeper module exists.

Good recommendations explain:
- which behaviors should be tested at the new interface
- which internal tests become redundant
- what local stand-ins, adapters, or fakes are needed

## RFC Shape

When writing an architecture RFC or issue draft, include:
- problem
- proposed boundary or interface
- dependency strategy
- testing strategy
- migration notes
