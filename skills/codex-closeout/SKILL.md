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
- writing a final reply for non-trivial repo work, live-ops work, local-brain
  work, PR cleanup, branch/git cleanup, or any change with verification,
  commit/push state, cleanup state, and residual risk

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
- close only after the current goal is actually satisfied or a real blocker is named

## Completion Gate

Before writing a final closeout, verify the work is genuinely done against the
latest user instruction, not an older plan that is still in your head.

Ask:

- Did the newest user message change the scope, priority, or stop condition?
- If an active goal exists, has it been completed or blocked with evidence?
- Did every promised edit, review, sync, test, install, commit, push, cleanup,
  or report step either run or get named as a real blocker?
- Did any essential skill gate apply, such as `mira-review-gate`,
  `codex-html-report`, `vincent-workflow`, `infisical-secrets-management`, a
  domain-specific owner skill, or `anti-ai-writing`, and did that owner skill
  actually run before closeout?
- Are repo changes committed and pushed when the current task granted that
  authority, or is the exact reason for skipping named?
- Are installed/runtime mirrors aligned when skills, hooks, or local toolkit
  files changed?
- Is the final answer about the actual finished state, not just the last
  successful sub-step?

If the answer is no, keep working. Use a short progress update instead of a
final closeout.

Mandatory trigger: before the final answer for non-trivial repo or live-ops work, local-brain work that used `second-brain-context`, PR or branch cleanup,
implementation with verification, or any task involving commit/push and
residual-risk state, load this skill and apply the completion gate. If another
owner skill routed final delivery here, treat that as an essential skill gate,
not an optional formatting preference.

## Coordination

This skill owns the final chat shape, not durable workflow state.
When multiple agents, personas, services, or handoff owners are involved, preserve their identity and handoff boundaries and do not blur who owns the action in the thread.

When the work used or should use `vincent-workflow`, make the closeout include
the workflow facts the user cares about:

- verification run and result
- commit/push/cleanup status for repo changes
- workflow file created or updated, if any
- remaining blocker or decision, only when real

Do not create separate blocker, decision, or handoff formats here. Use
`vincent-workflow` for those records and summarize them in the closeout.

If the work is destructive or could be destructive, include a dedicated destructive action status note: list each action and mark it as avoided, run, or blocked pending approval, then state outcome.

If the work approaches consent-changing action, final submission, public posting, destructive cleanup, live infra mutation, billing, credential movement, or other approval-gated action, state the consent or approval status plainly. Do not let a closeout imply an approval that was not granted.

For live infra work, distinguish dry-run proof, staging proof, and live infra proof. Name which layer was verified and which layer was not touched.

If the work produced a browser-native artifact, use `codex-html-report` for the
artifact and keep the chat closeout compact: report path, status, verification,
and any real limitation.

## Default Shape

For normal implementation work, prefer this order:

1. Outcome
2. What changed
3. Verification
4. Commit, push, or cleanup status when repo files changed
5. Destructive action status (avoided, run, or needs approval)
6. Remaining risk or next move, only if useful

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
- mention commit and push status when repo files changed
- mention only 1 to 4 files when they add real value
- treat secret, credential, token, and private key handling as sensitive output boundaries
- if destructive actions occurred or were avoided, include them in a separate destructive action status note and state whether approval was required and whether it was granted
- for Infisical or other secret-manager work, report redacted proof, secret location metadata, consumer state, and verification outcome only

When a task involves any secret, credential, token, or private key, only include what was touched and verified, not raw values.

Do not:
- default to a full report every turn
- restate the same framing headers repeatedly
- dump long file lists
- narrate every micro-step
- include a risks section if there is no meaningful residual risk
- include raw secret, credential, token, or private key values in closeout text

If those items were part of the work, include redacted confirmation, location metadata, and verification outcome only.

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
