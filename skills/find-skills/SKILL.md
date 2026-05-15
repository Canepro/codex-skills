---
name: find-skills
description: Helps users discover and install agent skills when they ask questions like "how do I do X", "find a skill for X", "is there a skill that can...", or express interest in extending capabilities. Use this when the user is looking for functionality that might already exist as a skill.
---

# Find Skills

Use this skill when the user is really asking whether a skill already exists for the job.

## When to use

- The user asks how to do something that might map to an existing skill
- The user asks for a skill recommendation or installable capability
- The user wants to extend Codex with a reusable workflow
- The user says they wish the agent had help for a specific domain

## Workflow

1. Check the current session skill catalog first.
2. If a relevant local skill already exists, recommend or use that instead of installing more drift.
3. If no local skill fits, search the broader ecosystem with the Skills CLI.
4. Verify quality before recommending anything.
5. If the user wants the capability to persist across machines, promote it into the configured `codex-skills` library checkout instead of leaving it as an unmanaged local extra.

## Skills CLI

The Skills CLI is the package manager for the broader skill ecosystem.

Useful commands:

```bash
npx skills find [query]
npx skills add <package>
npx skills check
npx skills update
```

Browse catalog listings at `https://skills.sh/`.

## Quality checks before recommending a skill

- Prefer well-known sources over unknown publishers.
- Prefer skills with meaningful adoption over barely used packages.
- Check the source repository when trust or maintenance quality is unclear.
- Do not recommend a skill based only on a search result title.

## Response pattern

When you find a relevant skill, tell the user:

- the skill name
- what it helps with
- where it comes from
- why it looks trustworthy
- how to install it

If the user wants it to become part of their durable Codex environment, add it to the configured `codex-skills` library workflow instead of stopping at a local one-off install.

## When nothing relevant exists

If you cannot find a suitable skill:

- say that clearly
- offer to handle the task directly
- suggest creating a new skill if the workflow is worth reusing
