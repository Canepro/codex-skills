---
name: recall
description: Rebuild recent working context for a topic before starting or resuming work, from shared memory, live git and gh state, and the shared record, then hand back a tight current-state brief. Use for "catch me up", "where did I leave off", "what have I been working on", or "recall my work on X". Never mines chat transcripts.
metadata:
  upstream: https://github.com/cursor/plugins/tree/main/pstack/skills/recall
  upstream-commit: c5db7fef1f1b1ebb2d4b7ae0308bf4beb10cb4c1
  adapted-for: transcript-free context recall
---

# Recall

Before you start or resume work, rebuild the recent working context for the
named topic and hand back a short brief: where things stand now and what to do
next. Use it for "catch me up", "where did I leave off", "what have I been
working on", or "recall my work on X".

This workflow adapts pstack's `recall` without transcript mining. Never read
chat transcripts, raw session logs, agent-transcript directories, browser
history, or another project's private records to reconstruct context. If the
user already gave you a full state capsule (paths, branch, the change), use it
and skip the search.

## Records you may read

Context lives in three records. All of them are durable and shared by design.

- Shared memory. The registered memory server (`second-brain` when it is
  registered) holds handoffs, decisions, corrections, and evidence written at
  task closeout. Search it by topic first.
- Live workspace state. `git` (branches, log, status, tagged stash entries) and
  `gh` (pull requests, issues, checks, review threads) for the current
  repository. Repository-owned handoff, plan, and decision-ledger files count
  here, including `show-me-your-work` ledgers.
- The shared record. Source control history, the issue tracker, long-form docs,
  team chat, and error tracking. When the `why` skill is installed, hand the
  sweep to its per-source investigators and steer the question to "what is the
  current state, what was tried and did not hold, and what are users still
  reporting". Without `why`, run the same sweep yourself, one source at a time.

## Steps

1. Classify, then route. Resuming one specific prior session from its handoff
   file is a pickup, not recall. A human-readable summary of your own work is a
   different task. Recall loads working context before you act.
2. Lock the scope before searching. Pin the window ("recent" is a real range;
   default the last 7 days), the topic if named, and the workspace (default the
   active one). State the scope back. Never quietly turn "all" into "recent N".
3. Search shared memory. Query by topic, then by the artifacts it names
   (branch, PR, ticket, file). Keep findings, not records: for each hit, note
   the goal, decisions, open threads, corrections, and artifacts, and cite the
   record id or path.
4. Sweep the shared record whenever the topic names a feature, file,
   subsystem, area, or bug. This is the default, not a judgment call. One
   investigator per source. Null results are findings. Skip an unavailable MCP
   and say so. Skip this step only for pure activity recall with no named
   target, where memory and live state are the entire answer.
5. Verify against live state. Memory and stale tickets are history, not
   current truth. Check every PR, branch, and ticket that steps 3 and 4
   surfaced with `git` and `gh` before you report its status.
6. Write the brief to the contract below. Group by thread. Stay on the named
   topic.

## Output contract

Lead with the capsule, then the thread status, then the problems, then the
next move. Deeper detail goes below or gets cut.

- Capsule. At most 5 bullets. What this work is and where it stands overall.
- Threads. One line each, prefixed with exactly one status tag: `[merged #N]`,
  `[open PR #N]`, `[in flight <branch>]`, `[verified, uncommitted]`,
  `[reverted #N]`, or `[planned, not started]`. A thread with no tag is not
  done yet, so tag it.
- Problems. At most 5, the recurring ones. Include the symptoms users keep
  reporting and any fix that shipped and was reverted, so the next attempt
  starts where the last one failed.
- Next move. The single most useful next action, concrete.

An adjacent feature or ticket stays out unless it blocks this one. When the
capsule and thread lines outgrow a screen, cut detail before you cut threads.
Cite memory findings by record id and shared-record findings by their source
(PR number, ticket id, doc link, error-tracker issue). Sanitize private
context before any output that leaves the workspace. Write the brief through
`unslop` when it is installed.
