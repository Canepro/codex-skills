---
name: show-me-your-work
description: Keep a compact, reviewable decision ledger for long-running or unattended work. Use when a reviewer needs to reconstruct consequential choices and their evidence without reading private transcripts or replaying the entire task.
metadata:
  upstream: https://github.com/cursor/plugins/tree/main/pstack/skills/show-me-your-work
  upstream-commit: 60c641e4fad674784b30abcf9f8915dea39df38d
  adapted-for: transcript-free evidence logging
---

# Show me your work

Keep one decision ledger for the current task when a human will review the work
after the fact. Record choices that changed scope, design, safety, verification,
or disposition. Do not turn the ledger into a second transcript.

This workflow adapts pstack's `show-me-your-work` without transcript mining.
Never read unrelated chats, raw session logs, browser history, or private
records to reconstruct the ledger.

## Ledger format

Use a TSV file with this header:

```text
ts\tphase\tdecision\twhy\tevidence\tresult
```

Each cell stays on one line. Prefix spreadsheet-formula starters (`=`, `+`,
`-`, or `@`) with a single quote when content is not fully controlled.

- `ts`: ISO 8601 timestamp.
- `phase`: Short workstream or phase name.
- `decision`: The choice made.
- `why`: The constraint or tradeoff that led to it.
- `evidence`: A compact pointer such as a file and line, command result, issue,
  check run, screenshot, or artifact path.
- `result`: What happened after the choice.

## Location and scope

Default to an untracked scratch path for operational notes. Put the ledger in
the repository only when the user asked for a durable decision trail or the
repository's review contract requires it. Follow existing evidence-directory
conventions when they exist.

Log only decisions from the active task that you directly observed. Do not add
routine commands, commentary updates, or reconstructed reasoning. Never place
secret values, customer data, raw prompts, private messages, or full tool output
in the ledger.

## Review

Before handing back:

1. Compare the ledger with the current task's explicit plan, changed files,
   command results, and proof artifacts.
2. Remove any row whose evidence does not support the stated decision or
   result.
3. Add a missing consequential decision only when the current task still
   contains direct evidence for it.
4. Confirm every evidence pointer exists or is a stable external identifier.
5. State whether the ledger is untracked, committed, or intentionally omitted.

The final report should summarize the outcome. The ledger is supporting proof,
not a substitute for judgment.

