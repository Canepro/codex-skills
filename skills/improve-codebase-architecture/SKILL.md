---
name: improve-codebase-architecture
description: Explore a codebase for architectural refactors that deepen modules and reduce coupling. Use when the user wants refactoring ideas, architecture review, maintainability improvements, clearer boundaries, or a codebase that is easier for humans and agents to navigate.
metadata:
  short-description: Find and frame architectural improvement opportunities
---

# Improve Codebase Architecture

Explore the codebase as a maintainer would, notice where understanding breaks down, and turn that friction into concrete architectural recommendations. When a selected opportunity needs executor-grade plan files, hand it to `agent-plan-backlog`.

## Workflow

### 1. Explore for friction

Inspect the codebase broadly enough to notice:
- concepts spread across too many small files
- shallow modules whose interfaces are almost as complex as their internals
- seams where integration bugs are likely
- code that is hard to test except through fragile internals
- repeated orchestration logic that should probably live behind one boundary

The friction you experience is the signal.

### 2. Present candidates

Give the user a numbered list of architectural opportunities. For each candidate include:
- cluster: the modules or concepts involved
- why they are coupled
- dependency category: see [REFERENCE.md](REFERENCE.md)
- testing impact: which boundary tests would become possible

Do not jump straight to a final design for every candidate. Help the user choose where to go deeper.

### 3. Frame the chosen problem

Once the user picks a candidate, explain:
- what constraints the new boundary must satisfy
- what dependencies it must own or hide
- what should remain stable for callers
- a rough interface sketch if needed to ground the discussion

### 4. Design alternatives

Generate multiple distinct interface directions yourself. If the user explicitly asks for parallel agent work and the environment permits it, you may widen the exploration with sub-agents. Otherwise keep the work local.

For each design show:
- interface shape
- example usage
- what complexity it hides
- dependency strategy
- trade-offs

### 5. Recommend a direction

After comparison, recommend one direction or a hybrid. Be opinionated and explain why.

### 6. Produce an RFC or issue draft if needed

Default to a Markdown recommendation or RFC draft.

If the user wants a backlog of implementation plans for another agent, use `agent-plan-backlog` after the architecture opportunity is selected and vetted. This skill owns architecture discovery and recommendation; `agent-plan-backlog` owns commit-stamped plan files, STOP conditions, drift checks, and reconciliation.

If the user explicitly wants a GitHub issue:
- draft it first
- only then create it with `gh` if auth is available

## Guidance

- Prefer durable architecture language over file-path-level instructions.
- Focus on boundaries, responsibilities, and testability.
- Replace shallow internal tests with stronger boundary tests when recommending deepened modules.

## Workflow Coordination

This skill owns its domain work. Use `agent-plan-backlog` for executor-grade plan files and plan reconciliation. Use `vincent-workflow` for durable decisions, blockers, resume handoffs, known issues, commit/push/cleanup obligations, or project-local follow-up state. Use `codex-closeout` for final chat delivery, `codex-html-report` for durable reader-facing proof, and `second-brain-context` only for cross-repo or future local-brain retrieval.
