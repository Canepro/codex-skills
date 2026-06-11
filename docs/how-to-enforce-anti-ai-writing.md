# How to enforce anti-ai-writing everywhere

The `anti-ai-writing` skill lives in this repo at `skills/anti-ai-writing/SKILL.md`. The repo install script copies it to local agent install paths, but Claude Code, Claude Cowork (claude.ai), and Cursor each need a one-time instruction so the skill runs as a mandatory finishing pass on every reply.

## Paste block

Use the same block on every surface. It mirrors the writing-style section in `~/.claude/CLAUDE.md`.

```text
Apply the anti-ai-writing skill as a mandatory finishing pass on every piece of user-facing prose you produce, in every project and session. That includes documentation, READMEs, blog posts, PR and issue descriptions, commit messages, code comments, and chat replies. Treat this as non-negotiable: do not return prose without applying the pass, even when not explicitly asked.

Hard rules enforced on every reply:

- Never use em dashes or en dashes. Use a comma, period, colon, or parentheses instead, and write "to" for number ranges. Ordinary hyphens in compound words (source-bound, dry-run, post-fix) are fine.
- No chatbot openers ("Certainly!", "Great question!", "I hope this helps"), prompt restatement, or reasoning scaffolding ("Let me think step by step").
- No greeting filler ("Welcome back", "Let's get started"), no mood headers ("Your AI insights"), no generic closers ("In conclusion", "The future looks bright").
- Lead with the answer, decision, or ask in the first two lines. Stop after the useful action, no closing recap unless the format calls for one.
- Strip stock vocabulary on sight: delve, tapestry, realm, leverage, robust, comprehensive, seamless, holistic, actionable, learnings, paradigm, ecosystem, watershed, nestled, vibrant.
- Name the actor. Prefer "the team chose" over "the decision emerged".
```

## Where to paste it

### Claude Code (local)

Already done if you cloned this repo and ran `scripts/bootstrap.sh`. The repo installer manages the Claude Code skill directory at `~/.claude/skills/anti-ai-writing/SKILL.md`, the same directory layout Claude Code discovers natively (flat `<name>.md` files were the old install format and are removed on install). The paste block lives in `~/.claude/CLAUDE.md` under "Writing style (always)" and loads into every Claude Code session.

To refresh after an upstream change, run `bash scripts/install.sh` from the repo root.

### Claude Cowork (claude.ai)

Two surfaces, paste the same block on both:

1. Settings, Profile, Personal preferences. Applies account-wide, including every Cowork project.
2. Per project, Custom instructions or Project knowledge. Use this when you want a local override or want a project's contributors to inherit the rule.

There is no programmatic install path for Cowork. Pasting is the install.

### Cursor

The repo also ships Cursor rules templates. After `scripts/install.sh`:

- Global: paste `~/.cursor/codex-skills-rules/USER-RULE-anti-ai.txt` into Cursor Settings, Rules, User Rules.
- Per project: copy `~/.cursor/codex-skills-rules/anti-ai-writing.mdc` to `.cursor/rules/anti-ai-writing.mdc` in the target repo.

### Codex CLI

Already covered by the repo install. The directory form lives at `~/.codex/skills/anti-ai-writing/SKILL.md` and is picked up by Codex on next launch.

## Verifying it works

After install or paste:

- Restart the agent (Claude Code, Cowork tab, Cursor, Codex).
- Ask the agent for a short paragraph on any topic.
- Confirm the reply has no em dashes, no greeting opener, and leads with the point. If any of those appear, the instruction is not loaded.

## When the skill itself changes

When `skills/anti-ai-writing/SKILL.md` in this repo gets edited:

1. Run `bash scripts/install.sh` to refresh local installs.
2. Re-paste the paste block above if its content changed materially. Only the top-line rules live in the paste block, so most skill edits do not require a re-paste.
3. For Cowork, re-paste under Personal preferences and any affected project.
