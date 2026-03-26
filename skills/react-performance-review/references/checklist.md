# React Performance Checklist

## Rendering model

- Are client components used only where needed?
- Is server rendering or streaming available but underused?
- Are large trees rerendering from broad state changes?

## State placement

- Is state lifted higher than necessary?
- Can expensive derived data move out of render?
- Are transitions or deferred values appropriate for non-urgent updates?

## Large collections

- Are lists virtualized when size makes it necessary?
- Are filters, sorts, and searches recomputed too often?
- Is item rendering heavier than the task requires?

## Bundle and hydration

- Are heavy client libraries loaded on the critical path?
- Can code-splitting or route segmentation help?
- Is hydration doing work that could stay on the server?

## Anti-patterns

- blanket `useMemo` / `useCallback` with no measured reason
- moving all state global by default
- forcing client rendering for convenience
- optimizing component internals before fixing the data flow
