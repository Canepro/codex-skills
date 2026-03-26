---
name: codex-closeout
description: Use when finishing implementation work, summarizing progress, or giving a Codex app closeout after code, config, infra, automation, script, doc, or test changes. Helps produce concise, high-signal delivery notes with outcome first, compact verification, minimal file inventory, and only real risks.
---

# Codex Closeout

Use this skill when:
- finishing a meaningful implementation step
- summarizing work completed in the Codex app
- reporting verification results after changes
- giving a checkpoint, handoff, or commit summary

Do not use this skill for:
- code reviews where findings should dominate
- design brainstorming
- long architecture writeups unless the user explicitly wants depth
- status theater or changelog-style narration

## Goal

Produce a closeout that is easy to scan in the Codex app:
- lead with outcome
- explain the user-visible or operator-visible effect
- keep verification explicit but compact
- mention only the most important files
- mention risks only when they are real

## Default Shape

For normal implementation work, prefer this order:

1. Outcome
2. What changed
3. Verification
4. Remaining risk or next move, only if useful

Use 2 to 4 short paragraphs or a very short flat list.

Preferred pattern:
- first sentence: what is now true
- second sentence: where it landed if relevant, such as branch or commit
- short paragraph: what materially changed
- short verification block
- optional short risk or next-step line

## Keep It Tight

Do:
- lead with the result
- summarize behavior, not edit inventory
- include exact validation commands
- mention commits when useful
- include 1 to 4 file references only when they add real value

Do not:
- default to a full report every turn
- restate the same framing headers repeatedly
- dump long file lists
- narrate every micro-step
- include a risks section if there is no meaningful residual risk

## When To Use The Full Structure

Use the full:
1. Findings
2. Proposed change
3. Exact changes
4. Verification
5. Risks / rollback

only when:
- the task is architecturally important
- the change is risky or controversial
- the user explicitly asked for a full structured report
- you are reviewing rather than implementing
- multiple non-obvious tradeoffs need to be preserved in the thread

Otherwise compress.

## Verification Block Rules

Always include:
- what you ran
- what passed
- what failed
- any important limitation

Prefer:
- one compact block
- grouped commands
- grouped results

Good:
- `bun test ...`
- `bun run typecheck`
- `git diff --check`

`Passed: 152 tests, typecheck passed, diff check passed.`

## File Reference Rules

Mention files only when one of these is true:
- the user may want to inspect that exact implementation
- the file is the main behavior boundary
- the file is the public contract or operator-facing surface

Prefer naming the 1 to 3 most important files over listing everything touched.

## Risk Rules

If no real residual risk exists, omit the risk section.

If risk exists, keep it short:
- one sentence for the main remaining gap
- one sentence for rollback if needed

## Next-Step Rules

Do not dump a menu of options by default.
Recommend the best next move and explain why in one sentence.

Only provide multiple options if the tradeoff is genuinely non-obvious.
