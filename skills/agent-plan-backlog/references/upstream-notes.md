# Upstream Notes

This skill adapts the useful mechanics from `shadcn/improve` without copying its command surface wholesale.

Source:
- https://github.com/shadcn/improve

Adopted mechanics:
- advisor and executor role split
- read-only advisor mode
- numbered `plans/` backlog
- commit-stamped drift checks
- self-contained plan files
- verification gates
- explicit out-of-scope lists
- STOP conditions
- reconcile loop for stale, blocked, done, and rejected plans

Local integration choices:
- `vincent-workflow` owns durable decisions, blockers, handoffs, and cleanup state.
- `agent-plan-backlog` owns only executor-grade plan files and plan reconciliation.
- Existing domain skills remain discovery feeders instead of being replaced.
