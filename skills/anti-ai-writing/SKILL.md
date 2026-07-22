---
name: anti-ai-writing
description: "Rewrite, detect, or edit prose when the user explicitly asks for less AI, human, natural, less corporate, or an anti-AI audit, or names important public copy for a dedicated polish pass. Not for ordinary chat, commits, handoffs, or routine technical prose."
---

# Anti-AI Writing

Use this when prose quality is the task. The goal is better writing: clear point,
concrete evidence, plain language, accountable claims, and a useful ending. Do
not optimize for detector evasion.

Keep useful voice and judgment, but remove generic assistant filler, corporate fog, and model-interface artifacts.

## When To Use

Load this skill when the user asks for anti-AI, less AI, human, natural, less
corporate, less generic, detect-only, audit-only, or editing a named file. It
may also be used for a dedicated polish pass on important public copy when the
task explicitly includes writing quality.

Do not load it automatically for ordinary chat, progress updates, commit
messages, PR summaries, handoffs, support drafts, emails, documentation, or
technical reports. Use the model's normal writing ability unless Vincent asks
for this specialist pass.

Do not use this skill to strip needed nuance, evidence, personality, or the user's voice. Direct does not mean flat.

## Modes

Default to `rewrite` unless the user asks for another mode.

- `rewrite`: identify the main writing problems, return the improved prose, and summarize meaningful changes.
- `detect`: flag issues only. Use when the user says detect, scan, audit only, flag only, or does not want the text changed.
- `edit`: modify a named local file in place. Keep edits minimal. Do not rewrite clean passages. Do not edit quoted material, code blocks, or attributed text unless the user explicitly asks.

For large files, narrow to the relevant section before editing. After edit mode, re-read the touched file and report what changed.

## Severity

Prioritize the highest-risk problems first.

- P0 credibility killers: fabricated or vague attribution, leaked chatbot artifacts, leaked citation tokens, cutoff disclaimers, unfilled placeholders, routine events inflated into historic claims.
- P1 obvious AI tells: stock vocabulary, formulaic openings, excessive bullets, bold overuse, emoji headers, generic conclusions, unsupported superlatives, synonym cycling, repetitive transitions, social engagement bait.
- P2 polish issues: uniform rhythm, mild hedging, weak sentence order, overlong paragraphs, redundant section headers, small tone mismatches.

For quick work, fix P0 and P1. For prose that will be sent, committed, published, or reused, run the full pass.

## Context Handling

Infer the context when the user does not name one.

- `chat`: concise, direct, warm when appropriate. No generic assistant sign-offs.
- `docs`: clarity first. Lists and tables are fine when genuinely useful.
- `technical`: keep precise terms. Do not replace technical words just because they appear in the word table.
- `review`: findings first, grounded in evidence. Keep summary secondary.
- `proposal` or `report`: lead with status, decision, evidence, risks, and next action.
- `email` or `handoff`: name the ask, owner, deadline, and blocker.
- `social`: short rhythm is acceptable, but avoid hooks that sell ordinary facts as revelations.
- `ui`: button labels are verbs, headings name the object or state, empty states give the next action, errors name the field and what to do, no greetings, no mood headers, no "let's get started" filler. Pair this with `frontend-anti-slop` when reviewing a UI change.

If a rule conflicts with the context, choose the clearer version for the reader. Technical accuracy beats style cleanup.

## Voice Handling

Match the user's existing voice unless they ask for a different one.

- `technical`: precise nouns, short instructions, active voice, no decorative phrasing.
- `warm`: humane and concrete, with no performative empathy.
- `blunt`: lead with the claim, cut hedges, keep the ending short.
- `professional`: one clear point per paragraph, explicit ask, low tolerance for vague claims.
- `casual`: contractions are fine, fragments are fine, and plain words beat polished abstractions.

If the user provides a writing sample, match its sentence length, register, contraction use, and recurring vocabulary. Do not "upgrade" the voice into corporate prose.

## Editing Pass

1. Put the answer, decision, or ask in the first two lines.
2. Remove slow buildup, throat clearing, prompt restatement, and generic context.
3. Replace inflated words with plain words unless the original term is technically precise.
4. Cut vague confidence. Say what is known, inferred, unverified, or blocked.
5. Name the actor. Prefer "the team changed..." over "the decision emerged..." or "the data says...".
6. Replace abstract importance claims with the actual consequence, risk, constraint, or action.
7. Add specifics where they exist: names, dates, numbers, file paths, commands, sources, failure modes.
8. Vary sentence and paragraph length. Avoid symmetry across bullets and paragraphs.
9. Preserve useful imperfection: contractions, fragments, and plain first-person are fine when they fit the voice.
10. Stop after the useful action. Do not add a closing recap unless the format needs one.

## Kill These Patterns

### Interface Artifacts

- Chatbot openers and rewards: "Certainly!", "Great question!", "Absolutely!", "I hope this helps".
- Prompt restatement: "You're asking about...", "To answer your question...".
- Reasoning scaffolding: "Let me think step by step", "Breaking this down", "First, let's consider".
- Cutoff disclaimers: "As of my last update", "I do not have real-time access". Verify or say the current limitation directly.
- Leaked citation or tool markup: `turn0search0`, `contentReference`, `oai_citation`, `[attached_file:1]`, `utm_source=chatgpt.com`, `utm_source=openai`, `utm_source=claude.ai`.
- Unfilled placeholders: `[Your Name]`, `[INSERT SOURCE]`, `2026-XX-XX`, TODO comments left in publishable prose.

### UI Microcopy Artifacts

These belong to the UI but the same rules apply. Strip them in the same pass.

- Greeting filler: "Welcome back, {name}!", "Good morning, Alex!", "Hi there!".
- Mood headers: "Let's get started", "You're all set!", "Awesome work!", "Your AI insights".
- Cheerleader empty states: "Nothing here yet, but exciting things are coming!".
- Reassurance copy on forms: "We will never spam you, promise", "This helps us personalize your experience".
- Verbose confirmations: "Are you absolutely sure you want to do this? This action cannot be undone and we want to make sure you have considered it." Replace with the concrete consequence and a verb-led button.
- Button labels that are moods or nouns: "Continue your journey", "Get started", "Explore". Replace with the verb for the actual action: "Save changes", "Create ticket", "Delete project".
- Error copy that hides the field: "Something went wrong, please try again." Name the field and the fix.

### Framing And Transitions

- Stiff transitions: "Furthermore", "Moreover", "Additionally". Use a real connection or cut.
- Broad scene-setting: "In today's world", "In an era where", "When it comes to".
- Reader-steering frames: "Here's what stood out", "The interesting part", "It is important to note".
- Infomercial hooks: "The catch?", "The kicker?", "Here's the thing", "Plot twist".
- Generic closers: "In conclusion", "In summary", "The future looks bright", "Only time will tell".
- Social bait: "Save this", "Bookmark this", "Thank me later", "This one is worth your time" without a concrete reason.

### Sentence Shapes

- Formulaic contrast: "not X, but Y" or "this is not about X, it is about Y" when a direct claim works.
- False concession: "While X is impressive, Y remains a challenge" unless both sides are specific.
- Hedge stacks: "could potentially", "may eventually", "might possibly".
- Hollow intensifiers: "truly", "genuine", "real", "actual", "undoubtedly", "make no mistake" unless the contrast is named.
- Rule-of-three padding: three adjectives, three nouns, or three parallel clauses when two or one would be stronger.
- Rhetorical question openers that delay the point.
- Parenthetical hedging that should be its own sentence or cut.

### Vocabulary To Challenge

Replace or rewrite these unless context makes them exact:

- Always suspicious: delve, tapestry, realm, paradigm, embark, beacon, testament to, robust, comprehensive, cutting-edge, leverage, pivotal, underscores, meticulous, seamless, game-changer, utilize, watershed moment, nestled, vibrant, thriving, showcase, deep dive, unpack, bustling, intricate, ever-evolving, daunting, holistic, actionable, impactful, learnings, thought leadership, best practices, synergy, interplay, serves as, boasts, commence, ascertain, endeavor.
- Suspicious in clusters: harness, navigate, foster, elevate, unleash, streamline, empower, bolster, spearhead, resonate, revolutionize, facilitate, underpin, nuanced, crucial, multifaceted, ecosystem, myriad, plethora, encompass, catalyze, reimagine, galvanize, augment, cultivate, illuminate, elucidate, juxtapose, transformative, cornerstone, paramount, poised, burgeoning, nascent, quintessential, overarching.
- Weak when repeated: significant, innovative, effective, dynamic, scalable, compelling, unprecedented, exceptional, remarkable, sophisticated, instrumental, world-class, state-of-the-art, best-in-class.

Do not do mechanical find-and-replace. Ask what the sentence is trying to say, then use the clearest word.

## Structure Checks

- Passive voice: if the sentence hides the actor, name the person, team, system, or source that acted.
- False agency: data does not "say", decisions do not "emerge", and culture does not "shift" by itself.
- Vague attribution: replace "experts believe" or "research shows" with a named source, or remove the attribution.
- Significance inflation: routine work does not become historic because the sentence says so.
- Speculative gap filling: cut guesses such as "likely began," "appears to have," or "maintains a low profile" unless sourced.
- Synonym cycling: repeat the clear word instead of rotating through thesaurus variants.
- Copula avoidance: prefer "is" and "has" over "serves as", "features", "boasts", or "presents" when no meaning is lost.
- Excessive structure: too many headers, too many bullets, and list items with the same grammar usually mean the prose needs a paragraph.
- Bare noun bullet lists: rewrite marketing-like bullets into claims with verbs and evidence.
- Self-labeling significance: cut lines like "this is the key part" and make the explanation carry the weight.
- Treadmill effect: each paragraph must add one new fact, claim, decision, risk, or action. If it does not, cut or merge it.
- Paragraph reshuffle test: if body paragraphs can be swapped without breaking the argument, add a through-line or make it a true list.

## Formatting Rules

- No em dash or en dash characters in final prose. Use commas, periods, colons, semicolons, parentheses, or normal hyphens.
- Keep letter-perfect technical strings, commands, URLs, file paths, API names, and quoted source text.
- Use bold sparingly. If a phrase needs bold to carry importance, lead with the point instead.
- Avoid emoji in headings. Use icons only when the surrounding product surface calls for them.
- Use sentence case headings unless the target platform requires title case.
- Do not remove bullets from genuine lists: steps, parameters, changelogs, findings, acceptance criteria, or commands.

## Preserve These

- Specific evidence, file paths, commands, ticket numbers, dates, source references, and quoted facts.
- The user's preferred words and cadence when they are clear and effective.
- Warmth, humor, or personality when it is earned by the context.
- Technical nuance that changes the decision.
- Clear uncertainty when evidence is incomplete.
- Safety, consent, legal, financial, medical, security, and credential boundaries.

## Output Format

For normal chat replies, return only the polished answer. Do not expose the audit unless useful.

For explicit rewrite requests, use:
1. Issues found
2. Rewritten version
3. What changed
4. Second-pass audit

For detect mode, use:
1. Issues found, grouped by P0/P1/P2
2. Assessment, including which flags are definite problems and which are judgment calls

For edit mode, report:
- files changed
- high-level edits made
- verification performed
- any remaining risk or skipped section

## Final Check

Before returning prose, ask:

- Does the first sentence carry the point?
- Does every paragraph earn its place?
- Would a real person say this in the intended channel?
- Is the next action concrete?
- Does each important claim name the actor or evidence?
- Did the pass preserve necessary nuance and voice?
- Are there any em dash or en dash characters? Remove them.
- Are there any phrases this skill itself bans? Remove them unless quoted as examples.
