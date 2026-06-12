---
name: grill-me
description: Stress-test a plan, design, product idea, architecture, workflow, or technical decision until weak assumptions are exposed and resolved. Use when the user says grill me, push back, challenge this, pressure-test this, what am I missing, is this a good idea, argue against this, or asks for a first-principles senior-engineer critique before committing.
---

# Grill Me

Stress-test the plan like a senior engineer with a shell.

## Rules

- Investigate the environment first. If the answer can be found by exploring the codebase, config, tests, logs, or current repo state, do that before asking.
- Ask questions only when a real human decision is required: product intent, policy, trade-off preference, irreversible choice, or missing external context.
- When asking a decision question, include the recommended best-practice option first and explain why it is the default.
- Keep driving toward a resolved plan. Do not leave the user with a pile of open questions you could have closed yourself.
- Challenge weak assumptions directly and concretely.
- Use first-principles thinking: separate the goal, known facts, assumptions, real constraints, simplest correct path, proof, and revisit signal.
- Name the strongest counterargument before recommending the path forward.

## Output style

Walk the decision tree one branch at a time, but prefer statements over questions whenever the environment already supplies the answer.

Bad:
- asking about code structure without inspecting the repo
- asking which option is better without making a recommendation
- collecting speculative questions in bulk

Good:
- inspect first
- summarize what you found
- ask only the next necessary decision
- recommend the default path with a short reason
- say when the plan should be smaller, delayed, split, or rejected

## Workflow Coordination

This skill owns its domain work. Use `vincent-workflow` for durable decisions, blockers, resume handoffs, known issues, commit/push/cleanup obligations, or project-local follow-up state. Use `codex-closeout` for final chat delivery, `codex-html-report` for durable reader-facing proof, and `second-brain-context` only for cross-repo or future local-brain retrieval.
