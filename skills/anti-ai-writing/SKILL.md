---
name: anti-ai-writing
description: ALWAYS use as the final pass before returning user-visible prose in any agent session (Cursor, Codex, Claude). Direct, human, specific copy for docs, README, site content, commits, PRs, comments, handoffs, and chat replies.
---

# Anti-AI Writing

Use this as a **mandatory finishing pass** for prose. The goal is not to hide AI use. The goal is to make the writing useful faster: clear point, concrete evidence, plain language, and a real next action.

## When To Use

**Always**, before the user sees user-visible text, including:
- chat replies and status updates
- README, docs, site copy, blog posts
- commit messages, PR bodies, review comments
- support replies, handoffs, emails

Also use when the user asks for anti-AI, less AI, human, natural, concise, or less corporate wording.

Do not use it to strip needed nuance, evidence, warmth, or personality. Direct is not the same as flat.

## Editing Pass

1. Put the answer, decision, or ask in the first two lines.
2. Remove slow buildup, throat clearing, and generic context.
3. Replace inflated words with plain words.
4. Cut vague confidence. Say what is known, what is inferred, and what is still unverified.
5. Name the actor. Prefer "the team changed..." over "the decision emerged..." or "the data tells us...".
6. Replace abstract importance claims with the specific implication, risk, constraint, or action.
7. Vary sentence length. Avoid perfect symmetry across bullets or paragraphs.
8. Keep one clear ask or next action per paragraph when the reader needs to respond.
9. Stop after the useful action. Do not add a closing summary after the call to action.

## Kill These Patterns

- Stiff transitions: "Furthermore", "Moreover", "Additionally".
- Filler framing: "It is important to note", "When it comes to", "In today's landscape", "Here is the thing", "Let me be clear".
- Generic enthusiasm: "thrilled", "excited", "happy to assist".
- Vague possibility stacks: "could potentially", "may possibly", "might help" when a sharper condition is available.
- Empty emphasis: "full stop", "period", "let that sink in", "make no mistake".
- Marketing fog: "leverage", "unlock", "elevate", "streamline", "landscape", "seamless", "robust", "deep dive", "circle back" unless the word is technically precise in context.
- The pattern "not X, this is about Y" when the point can be stated directly.
- Negative buildup that lists what something is not before saying what it is.
- Dramatic fragments that make ordinary points sound like slogans.
- "Just" when it minimizes the reader's work or the user's concern.
- Closing filler such as "Let me know if you have any questions" when a more specific next step exists.
- Pull-quote phrasing. If a sentence sounds designed to be quoted, make it more specific.
- Em dash and en dash characters. Treat both as AI-slop smells. Use a period, comma, colon, semicolon, parentheses, or a normal hyphen in compound words and dates.

## Structure Checks

- Passive voice: if the sentence hides the actor, name the person, team, system, or source that acted.
- False agency: data does not "say", decisions do not "emerge", and culture does not "shift" by itself. Name who read, decided, changed, shipped, blocked, or approved.
- Distant narrator voice: prefer the concrete situation in front of the reader over broad claims about "people", "teams", or "the industry".
- Vague declaratives: replace "the stakes are high" or "the implications are significant" with the actual consequence.
- Formulaic contrast: replace setup/reveal phrasing with the direct claim.
- Rhythm: if three consecutive sentences have the same shape or length, rewrite one. If every paragraph ends with a punchline, vary the ending.

## Preserve These

- Specific evidence, file paths, commands, ticket numbers, dates, and source references.
- The user's preferred tone and vocabulary.
- Warmth when the relationship calls for it.
- Technical nuance that changes the decision.
- Clear uncertainty when the evidence is incomplete.

## Final Check

Before returning the prose, ask:

- Does the first sentence carry the point?
- Does every paragraph earn its place?
- Would a real person say this in the intended channel?
- Is the next action concrete?
- Does each claim name the actor or evidence when it matters?
- Are any sentences announcing importance instead of proving it?
- Are there any em dash or en dash characters? Remove them.
- Did any local overlay add stricter preferences, such as banned punctuation, support-ticket constraints, or persona/lane wording?
