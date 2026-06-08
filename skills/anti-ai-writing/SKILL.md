---
name: anti-ai-writing
description: ALWAYS use as the final pass before returning user-visible prose in any agent session (Cursor, Codex, Claude). Direct, human, specific copy for docs, README, site content, commits, PRs, comments, handoffs, and chat replies. Supports rewrite, detect-only, and edit-in-place modes.
---

# Anti-AI Writing

Use this as a mandatory finishing pass for prose. The goal is better writing: clear point, concrete evidence, plain language, accountable claims, and a useful ending. Do not optimize for detector evasion.

Keep useful voice and judgment, but remove generic assistant filler, corporate fog, and model-interface artifacts.

## When To Use

Always, before the user sees user-visible text, including:
- chat replies and status updates
- README, docs, site copy, blog posts
- commit messages, PR bodies, review comments
- support replies, handoffs, emails

Also use when the user asks for anti-AI, less AI, human, natural, concise, less corporate, less generic, detect-only, audit-only, or edit a file in place.

Do not use this skill to strip needed nuance, evidence, personality, or the user's voice. Direct does not mean flat.

## Modes

Default to `rewrite` unless the user asks for another mode.

- `rewrite`: identify key writing risks, return the improved prose, and summarize meaningful changes.
- `detect`: flag issues only.
- `edit`: modify a named local file in place. Keep edits minimal.

Use edit mode for scoped updates only. For large files, target the relevant section.

## Core Pass

1. Put the answer, decision, or ask in the first two lines.
2. Use actor-first writing. Name who changed, approved, blocked, owned, and will act.
3. Keep concrete details: names, dates, paths, commands, owners, and outcomes.
4. Remove generic openers, formulaic transitions, and unsupported superlatives.
5. Replace vague claims with specific consequences, constraints, risks, or actions.
6. Preserve required nuance and the user's voice where it helps clarity.
7. End with a concrete next action.

## Kill-list (quoted bullet entries)

- "delve"
- "tapestry"
- "rich tapestry"
- "navigate the landscape"
- "weave"
- "ever-evolving"
- "Certainly!"
- "Great question!"
- "Absolutely!"
- "To answer your question..."
- "Here's what stood out"
- "In conclusion"
- "In summary"
- "Save this"
- "Thank me later"

Use only as examples. If these appear unquoted in prose, flag them.

## Structure and Clarity Checks

- Name who did the work so passive wording does not hide the actor.
- Replace "research shows", "data says", and similar claims without a named source.
- Cut speculative language unless explicitly marked as inference.
- Keep paragraphs serving a decision, risk, evidence, or action.
- Keep technical terms when they are precise.
- Avoid social bait and generic motivational closers.

## Safety and Boundaries

- Preserve evidence, consent posture, legal/security/credential boundaries.
- Do not expose token values, private data, or sensitive identity claims.
- Maintain the user's preferred style when it is explicit.

## Output Format

For normal chat replies, return only the polished answer.

For rewrite requests:
1. Issues found
2. Rewritten version
3. What changed
4. Second-pass audit

For detect requests:
1. Issues found, grouped by P0/P1/P2
2. Assessment of definite flags vs judgment calls

For edit requests:
1. Files changed
2. High-level edits made
3. Verification performed
4. Any remaining risk or skipped section

## Final Check

Before returning:
- Does the first sentence carry the point?
- Does the next action state what to do next and who owns it?
- Does every paragraph earn its place?
- Did you preserve evidence where needed?
- Are there any em dash or en dash characters?
- Are banned phrases in unquoted prose? Flag them now.
