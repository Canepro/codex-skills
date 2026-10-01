---
name: show-me-your-work
description: Keep a compact, reviewable decision ledger for long-running or unattended work. Use when a reviewer needs to reconstruct consequential choices and their evidence without reading private transcripts or replaying the entire task.
metadata:
  upstream: https://github.com/cursor/plugins/tree/main/pstack/skills/show-me-your-work
  upstream-commit: 2eb7ed4613cfc8f098dfe464a23680ea44d84c5e
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
- `phase`: Short workstream or phase name, or the reserved value `start`
  for a run-boundary row (below).
- `decision`: The choice made. On a `start` row, the `ts` range of the
  earlier rows this run did not write.
- `why`: The constraint or tradeoff that led to it.
- `evidence`: A compact pointer such as a file and line, command result, issue,
  check run, screenshot, or artifact path.
- `result`: What happened after the choice.

## Location and scope

Default to an untracked scratch path for operational notes. Put the ledger in
the repository only when the user asked for a durable decision trail or the
repository's review contract requires it. Follow existing evidence-directory
conventions when they exist.

Log only decisions from the active task that you directly observed, plus the
required `start` rows below. Do not add routine commands, commentary updates,
or reconstructed reasoning. Never place
secret values, customer data, raw prompts, private messages, or full tool output
in the ledger.

A run is one agent conversation, including its later turns. A pickup, a
replacement agent, or a new chat is a new run. When a run adds to a ledger that
already has rows, its first row uses phase `start`, and so does its first row
after another run's `start` row. Before writing, read the ledger's last rows to
see whether another run wrote since. A `start` row's `decision` names the `ts`
range of the rows this run did not write, and its `evidence` names this run
(for example its session or agent id). Use phase `start` for nothing else.

## Review

Before handing back:

1. Find each of this run's stretches. A stretch starts at one of this run's
   `start` rows, or at the first row when this run created the ledger, and
   ends at the next `start` row written by another run. A run that created the
   ledger and later returned after another run wrote has more than one
   stretch. Compare the decision rows in every stretch with the current task's
   explicit plan, changed files, command results, and proof artifacts. Rows
   outside these stretches are not audited here.
2. A `start` row is a run boundary, not a decision. Check only that its `ts`
   range matches the earlier rows and its `evidence` names this run.
3. Never edit or delete a row. When a decision row records no real decision or
   action, or its claim or evidence is wrong, add a row that supersedes it with
   what happened and a pointer that resolves. If this run's own work shows a
   row from another run is wrong, supersede it the same way.
4. Add a missing consequential decision only when the current task still
   contains direct evidence for it.
5. Confirm that every evidence pointer in this run's stretches exists or is a
   stable external identifier. Pointers in another run's rows may live on that
   run's scratch; do not supersede them only because they no longer resolve
   here.
6. State whether the ledger is untracked, committed, or intentionally omitted.

The final report should summarize the outcome. The ledger is supporting proof,
not a substitute for judgment.

