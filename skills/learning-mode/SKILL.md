---
name: learning-mode
description: Use when the user asks to learn, understand, walk through, internalize, explain, teach, drill, quiz, or verify comprehension of a topic, code path, system, bug, design, incident, or decision.
---

# Learning Mode

Use this skill when the user wants to understand the work, not merely receive the answer.

Do not use this mode for normal fix-and-ship tasks unless the user asks to learn or the request clearly depends on them building a mental model. Keep operational work moving when the task is execution, review, deployment, triage, or a direct answer.

## Goal

Help the user reason from first principles about the topic in front of them.

The session is complete only when the user has demonstrated understanding of the relevant checklist. Do not treat your explanation as proof that they understand it.

## Operating Pattern

Work in small checkpoints.

Before moving to the next layer, verify the current layer at two levels:

- Strategic: what problem exists, why it matters, and what tradeoff is being made.
- Mechanical: how the code, system, workflow, edge case, or failure path behaves.

Prefer concrete evidence over lecture:

- code references
- shell output
- debugger steps
- tests
- diagrams
- examples
- counterexamples
- short exercises

## Running Checklist

Maintain a visible checklist of what the user should understand. Keep it lightweight in chat unless the session is long enough to need a durable note.

Track:

1. The problem: what is broken, missing, confusing, risky, or unknown.
2. The cause: why the problem exists.
3. The model: the core concept or mechanism that explains the behavior.
4. The solution: what changed, should change, or should be chosen.
5. The tradeoffs: why this path is better than realistic alternatives.
6. The edge cases: where the idea fails, bends, or needs guardrails.
7. The impact: what changes for users, operators, maintainers, costs, reliability, security, or future work.

## Checkpoints

At each checkpoint:

1. Ask the user to restate the current model in their own words.
2. Identify gaps directly.
3. Fill the gaps with the smallest useful explanation.
4. Verify again with a concrete prompt, example, or task.
5. Move on only after the current checklist item is reasonably solid.

Use open-ended questions first:

- "What do you think this function is responsible for?"
- "Where would this fail if the input is empty?"
- "Why do you think this design avoids that race?"
- "What would you inspect next if this alert fired again?"

Use multiple choice when it helps isolate a misconception. If you use multiple choice, vary answer positions and do not reveal the answer before the user answers.

## Depth Controls

Use the depth the user asks for, or choose the lowest level that preserves correctness:

- ELI5: plain-language model and one simple analogy.
- ELI14: accurate technical explanation with light detail.
- Intern-level: code, data flow, failure modes, and debugging steps.
- Staff-level: architecture, tradeoffs, operational risk, ownership, and long-term maintenance.

If the user asks for a different depth mid-session, switch levels without restarting the whole explanation.

## When Code Is Involved

Anchor explanations in the actual codebase.

Prefer:

- reading the relevant files before explaining behavior
- pointing to exact functions, configs, tests, logs, or commits
- asking the user to predict behavior before running a command when that helps learning
- using the debugger, tests, or small repros when explanation alone is too fuzzy

Do not invent code behavior from memory when the files are available.

## Durable Notes

For longer sessions, create or update a running Markdown note only when useful. Keep it close to the work:

- repo-local docs when the lesson belongs to the project
- `work/` in a projectless Codex thread for temporary notes
- `outputs/` only for final user-facing learning artifacts

The note should include:

- current checklist
- what the user already demonstrated
- remaining gaps
- evidence or code references
- next exercise or checkpoint

## Stop Condition

Before closing a Learning Mode session, verify that the user can explain:

1. what the problem is
2. why it exists
3. how the solution works
4. why the chosen approach is reasonable
5. what edge cases still matter
6. what the broader impact is

If time or context runs out, state exactly which checklist items are complete and which remain open.

## Workflow Coordination

This skill owns teaching posture, checkpoints, and exercise design. Use `vincent-workflow` only when the learning session creates durable blockers, decisions, handoffs, known issues, or project cleanup obligations. Use repo-local docs when the lesson belongs to a project, and use `codex-html-report` only for durable reader-facing learning artifacts. Use `second-brain-context` when a verified lesson or preference should persist in the shared local brain. Use `codex-closeout` for final chat delivery.
