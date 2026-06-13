# Executor-Grade Plan Template

Use this shape for `plans/NNN-short-slug.md`.

```markdown
# Plan NNN: <imperative title>

> Executor instructions: Follow this plan step by step. Run each verification
> command before moving on. If any STOP condition occurs, stop and report. Do
> not improvise around it.
>
> Drift check: `git diff --stat <planned-at SHA>..HEAD -- <in-scope paths>`
> If any in-scope file changed, compare the current-state excerpts below with
> live code before proceeding. If they no longer match, stop and report.

## Status

- Priority: P1 | P2 | P3
- Effort: S | M | L
- Risk: LOW | MED | HIGH
- Depends on: none | plans/NNN-*.md
- Category: bug | security | perf | tests | tech-debt | migration | dx | docs | direction
- Planned at: commit `<short SHA>`, <YYYY-MM-DD>

## Why this matters

State the concrete cost and what improves when this lands.

## Current state

- `path/file.ext` - role and relevant lines.
- Short excerpts with `file:line` markers.
- Repo conventions to follow, including one exemplar file.

## Commands

| Purpose | Command | Expected result |
|---|---|---|
| Typecheck | `<command>` | exit 0 |
| Tests | `<command>` | named tests pass |

## Scope

In scope:
- `path/file.ext`

Out of scope:
- `path/other.ext` - why it must not be touched.

## Steps

### Step 1: <imperative title>

Precise action.

Verify: `<command>` -> expected result.

## Test plan

- New tests to add.
- Existing test pattern to copy.
- Full verification command.

## Done criteria

- [ ] <command> exits 0
- [ ] New tests cover <case>
- [ ] No files outside scope changed
- [ ] `plans/README.md` status row updated, unless the reviewer owns the index

## STOP conditions

Stop and report if:

- Current code does not match the excerpts.
- Verification fails twice after a reasonable fix attempt.
- The work requires an out-of-scope file.
- A named assumption is false.

## Maintenance notes

What reviewers should scrutinize and what future changes may need to revisit.
```

Use this shape for `plans/README.md`.

```markdown
# Implementation Plans

Generated on <YYYY-MM-DD>. Execute in order unless dependencies say otherwise.

## Execution order and status

| Plan | Title | Priority | Effort | Depends on | Status |
|---|---|---|---|---|---|
| 001 | ... | P1 | S | none | TODO |

Status values: TODO, IN PROGRESS, DONE, BLOCKED, REJECTED.

## Dependency notes

- 002 requires 001 because <reason>.

## Findings considered and rejected

- <finding>: not worth doing because <reason>.
```
