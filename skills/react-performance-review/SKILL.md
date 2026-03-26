---
name: react-performance-review
description: Review React applications for rendering inefficiency, unnecessary client work, bundle bloat, hydration cost, state placement problems, and slow interaction paths. Use when the user reports a slow React UI, wants a performance audit, or needs prioritized findings on what to fix before reaching for micro-optimizations.
metadata:
  short-description: Audit React rendering and bundle performance
---

# React Performance Review

Use this skill for performance diagnosis and prioritization in React applications.

## Use when

- the UI feels slow or janky
- rerenders seem excessive
- hydration or client-side work is too heavy
- bundles are larger than expected
- list rendering, search, filters, or typing interactions feel sluggish

## Do not use when

- the app is not meaningfully React-based
- the main task is generic frontend review. Use `frontend-review`.
- the main task is visual redesign. Use `frontend-uncodixfy`.
- the main task is browser automation. Use `webapp-testing`.

## Review priorities

Check in this order:
1. wrong rendering model or client/server boundary
2. unnecessary work during render
3. state placement and invalidation scope
4. expensive lists, filters, or derived views
5. bundle and hydration cost
6. only then smaller optimizations

## Workflow

### 1. Find the slow path

Identify:
- the specific interaction that feels slow
- whether the cost is render, network, bundle load, hydration, or layout
- whether the issue is local to one component or systemic

### 2. Inspect architecture before hooks

Look for:
- too much code in client components
- state lifted too high
- broad invalidation of large trees
- expensive derivations in render
- lists without virtualization where it matters

Do not default to sprinkling memoization everywhere.

### 3. Review the data and boundary model

Ask:
- should this be server-rendered instead?
- should this work happen outside render?
- can this state be localized?
- can this view be paginated, chunked, or virtualized?

### 4. Report findings with expected payoff

For each finding, state:
- what work is happening
- why it is costly
- the likely user-visible impact
- the highest-leverage fix

## Guidance

- Prefer fewer, higher-payoff fixes over a long list of tiny tweaks.
- Architectural changes beat incidental memoization.
- If you recommend memoization, explain the invalidation boundary clearly.

## References

- Read `references/checklist.md` for a React-specific performance checklist.
