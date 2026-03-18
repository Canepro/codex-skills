---
name: grill-me
description: Stress-test a plan or design until reaching shared understanding, resolving each branch of the decision tree. Use when user wants to stress-test a plan, get grilled on their design, or mentions "grill me".
---

# Grill Me

Stress-test the plan like a senior engineer with a shell.

## Rules

- Investigate the environment first. If the answer can be found by exploring the codebase, config, tests, logs, or current repo state, do that before asking.
- Ask questions only when a real human decision is required: product intent, policy, trade-off preference, irreversible choice, or missing external context.
- When asking a decision question, include the recommended best-practice option first and explain why it is the default.
- Keep driving toward a resolved plan. Do not leave the user with a pile of open questions you could have closed yourself.
- Challenge weak assumptions directly and concretely.

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
