---
name: grill-with-docs
description: "Stress-test a plan, design, architecture, or decision, grounding the critique in code, domain language, CONTEXT.md, and ADRs. Use for grill me, push back, challenge this, pressure-test this, what am I missing, is this a good idea, or a first-principles senior-engineer critique before committing."
metadata:
  short-description: Stress-test a plan against code and docs
  upstream: https://github.com/mattpocock/skills/tree/main/skills/engineering/grill-with-docs
---

# Grill With Docs

Stress-test the plan like a senior engineer with a shell, a domain glossary, and a low tolerance for fuzzy words.

This skill is adapted from Matt Pocock's `grill-with-docs`, `grilling`, and `domain-modeling` skills. The upstream `grill-with-docs` skill delegates to slash-command skills; this version is self-contained for Codex.

## Operating Rules

- Investigate the environment first. If the answer can be found by exploring the codebase, config, tests, logs, docs, ADRs, or current repo state, do that before asking.
- Ask one question at a time. Ask only when a real human decision is required: product intent, policy, trade-off preference, irreversible choice, or missing external context.
- For each decision question, provide the recommended answer first and explain why it is the default.
- Keep driving toward a resolved plan. Do not leave the user with a pile of open questions you could close yourself.
- Challenge weak assumptions directly and concretely.
- Use first-principles thinking: separate the goal, known facts, assumptions, real constraints, simplest correct path, proof, and revisit signal.
- Name the strongest counterargument before recommending the path forward.
- Prefer statements over questions whenever the environment already supplies the answer.

## Domain Awareness

During codebase exploration, also look for existing domain documentation:

- `CONTEXT-MAP.md` at the repo root for multi-context projects
- `CONTEXT.md` at the repo root or within the relevant bounded context
- `docs/adr/` for architectural decision records
- other repo-local glossary, architecture, or decision files when they clearly own the same concern

If `CONTEXT-MAP.md` exists, read it to identify the relevant context before editing or proposing terminology. If only `CONTEXT.md` exists, treat the repo as a single-context project. If neither exists, do not create one until the first domain term is actually resolved.

## Grilling Loop

Walk down the design tree one branch at a time:

1. State what is known from code, docs, tests, or runtime proof.
2. Identify the decision that remains unresolved.
3. Give the recommended answer and the strongest counterargument.
4. Ask the next necessary question, if a human choice is still required.
5. Wait for feedback before moving to the next branch.

Use concrete scenarios to expose edge cases and boundary violations. When the user says a system behaves a certain way, check whether the code agrees. If code and plan conflict, surface the contradiction and ask which source should win.

## Project Alignment

Keep the user and project state on the same page while grilling:

- If the plan touches an active repo, inspect existing workflow state before treating the discussion as fresh: `.localdev/workflow/todo.md`, `blockers.md`, `decisions.md`, `findings.md`, `handoffs/`, and `docs/KNOWN_ISSUES.md` when they exist.
- If the session produces a durable project decision, use `vincent-workflow` to record it in the appropriate workflow file instead of leaving it only in chat.
- If the session exposes an unresolved blocker, missing owner decision, or follow-up task that should survive this thread, route it through `vincent-workflow`.
- Do not create workflow files just because this skill ran. Create them only when project state needs to survive context loss, handoff, or future implementation work.
- Keep live clarification conversational and narrow: ask the next necessary question, record the decision when it crystallizes, then continue.

## Language Discipline

Challenge terms while the plan is still being shaped:

- If the user uses a term that conflicts with `CONTEXT.md`, call out the conflict immediately.
- If a term is vague or overloaded, propose a precise canonical term.
- If two words appear to mean the same thing, pick one and list the others as avoid terms.
- Do not add general programming concepts to domain docs. Only capture terms specific to the project context.

When a domain term is resolved and a `CONTEXT.md` already exists or is now clearly warranted, update it immediately. Keep `CONTEXT.md` as a glossary only, not a spec, scratch pad, or implementation-decision log.

Use this format:

```md
**Canonical Term**:
One or two sentences defining what the term is.
_Avoid_: Old name, ambiguous synonym
```

## ADR Discipline

Offer or create an ADR only when all three are true:

- The decision is hard to reverse.
- The decision will be surprising without context.
- The decision came from a real trade-off with meaningful alternatives.

Skip the ADR if the decision is obvious, easy to reverse, or lacks a real alternative. When an ADR is warranted, create `docs/adr/` lazily and use the next sequential filename, such as `0001-short-slug.md`.

Use a short ADR by default:

```md
# Short title of the decision

One to three sentences: what context mattered, what we decided, and why.
```

Add optional sections only when they add value: status, considered options, consequences, or rejected alternatives.

## Output Style

Bad:

- asking about code structure without inspecting the repo
- asking which option is better without making a recommendation
- collecting speculative questions in bulk
- writing glossary or ADR files before a decision has crystallized

Good:

- inspect first
- summarize what you found
- sharpen terminology inline
- ask only the next necessary question
- recommend the default path with a short reason
- say when the plan should be smaller, delayed, split, or rejected
- update docs only when the decision or term is real enough to survive the session

## Workflow Coordination

This skill owns plan interrogation, terminology sharpening, and warranted `CONTEXT.md` or ADR updates. Use `vincent-workflow` for durable decisions, blockers, resume handoffs, known issues, commit/push/cleanup obligations, or project-local follow-up state; a grill verdict that kills or reshapes a plan is a durable decision worth recording there. Use a review-gate skill (such as `mira-review-gate`) when the concern is completed work rather than a plan: this skill is the pre-decision pass, the gate is the post-work pass. Use `codex-closeout` for final chat delivery, `codex-html-report` for durable reader-facing proof, and `second-brain-context` only for cross-repo or future local-brain retrieval.
