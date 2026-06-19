---
name: gh-address-comments
description: Fetch and address review threads, review submissions, and conversation comments on the GitHub PR for the current branch using `gh` and the bundled fetch script. Use when PR comments need triage, summaries, drafted replies, or code changes; verify `gh` auth first and prompt for login if needed.
metadata:
  short-description: Address comments in a GitHub PR review
---

# PR Comment Handler

Find the PR associated with the current branch, collect every comment and review thread, and work through them with the user deciding what gets addressed. Run all `gh` commands with network access.

## Use when

- the user asks to address, triage, or summarize review comments on a PR
- review threads need drafted replies or code changes
- the user wants to know what is still unresolved before merging

## Do not use when

- the red thing on the PR is a failing check, not a human comment. Use `ci-pipeline-triage`.
- the user wants a fresh review of the diff with no existing comments. Review the change directly instead.
- the PR belongs to a different branch. Check out that branch first; the bundled script only resolves the current branch's PR.

## Prerequisites

- `gh` is authenticated: confirm with `gh auth status` (repo scope). If it fails, ask the user to run `gh auth login` once, then retry.
- The current branch has an associated PR; `gh pr view` resolves it, including cross-repo PRs.
- If sandboxing blocks `gh` network calls, rerun the command with escalated permissions.

## Workflow

1. Verify auth with `gh auth status`.
2. Fetch everything with the bundled script:
   - `python3 "<path-to-skill>/scripts/fetch_comments.py" > pr_comments.json`
   - If `python3` is not on `PATH`, run the script through its shebang: `"<path-to-skill>/scripts/fetch_comments.py" > pr_comments.json`
   - Do not fall back to `python` unless `python --version` proves it is Python 3.
3. Triage the output. Number each open item, lead with unresolved review threads and `CHANGES_REQUESTED` reviews, and give each a one-line summary of what a fix would take. Skip resolved and outdated threads unless the user asks for them.
4. Ask the user which numbered items to address.
5. Apply fixes for the selected items. Prefer the smallest change that closes the thread; keep unrelated cleanup out of the diff.
6. Reply and resolve when the user wants that done from here:
   - Top-level PR comment: `gh pr comment <pr> --body "..."`
   - Reply inside an inline thread, using the thread `id` from the script output:
     `gh api graphql -f query='mutation { addPullRequestReviewThreadReply(input:{pullRequestReviewThreadId:"<thread-id>", body:"..."}) { comment { url } } }'`
   - Resolve a thread: `gh api graphql -f query='mutation { resolveReviewThread(input:{threadId:"<thread-id>"}) { thread { isResolved } } }'`
7. Re-run the script to confirm the addressed threads now show `isResolved: true`, and summarize what was changed, replied to, and left open.

## Bundled script

`scripts/fetch_comments.py` takes no flags and operates on the current branch's PR. It resolves the PR with `gh pr view`, then pages through the GitHub GraphQL API (100 items per page) until all three collections are complete.

Output is one JSON document on stdout:

- `pull_request`: number, url, title, state, owner, repo
- `conversation_comments`: top-level PR comments (body, author, timestamps)
- `reviews`: review submissions with `state` (APPROVED, CHANGES_REQUESTED, COMMENTED) and body
- `review_threads`: inline threads with `isResolved`, `isOutdated`, `path`, `line`, `diffSide`, the resolver, and the full nested comment list

The `id` fields are GraphQL node ids; use them directly in the reply and resolve mutations above. The script exits non-zero with a message on stderr when `gh` is unauthenticated or the branch has no associated PR.

## Guidance

- Do not resolve someone else's thread without the user's go-ahead; reviewers often expect to resolve their own.
- Quote the reviewer's ask in your summary when it is ambiguous, and say what you would change before changing it.
- If `gh` hits auth or rate-limit errors mid-run, prompt the user to re-authenticate with `gh auth login`, then retry.
- For comments that are really CI failures pasted by a bot, switch to `ci-pipeline-triage` and say so.

## Workflow Coordination

This skill owns its domain work. Use `vincent-workflow` for durable decisions, blockers, resume handoffs, known issues, commit/push/cleanup obligations, or project-local follow-up state. Use `codex-closeout` for final chat delivery, `codex-html-report` for durable reader-facing proof, and `second-brain-context` only for cross-repo or future local-brain retrieval.
