# Skill Authoring Best Practices

External consensus on writing agent skills, checked against this library on 2026-06-11. Sources: [Anthropic's skill authoring guide](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices), [agentskills.io best practices](https://agentskills.io/skill-creation/best-practices), [Anthropic engineering blog](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills), and [Phil Schmid's 8 tips](https://www.philschmid.de/agent-skills-tips).

## Frontmatter and triggering

- `name`: max 64 chars, lowercase letters, numbers, hyphens. Gerund or noun phrases both fine; avoid vague names like `helper` or `utils`.
- `description`: max 1024 chars, third person, and it must cover both what the skill does and when to use it, with the concrete words a user would type. This is the only text the agent sees when routing, so specificity here beats anything in the body.
- State negative triggers. Our "Do not use when" sections do this in the body; the description should carry the strongest exclusions too when collisions are likely.
- Never write persona descriptions ("Expert in X"). They describe a character, not a trigger.
- Vendored skills keep their upstream wording. Skills imported from a vendor or another author (for example `hatch-pet`, `chronicle`, `terraform-skill`, anything carrying its own `repository` and `author` frontmatter) are not ours to trim or restyle; leave their descriptions and bodies intact and route around them instead. `scripts/check-workflow-links.py` skips those explicitly vendored upstream skills; local wrapper skills and docs own the routing.
- The whole catalog is budgeted, not just each description: Codex advertises roughly 8,000 characters (about 2% of context) of skill metadata per session, shortens long descriptions first, and silently omits skills when still over budget. With a large installed set, every extra character raises some skill's omission risk, so keep descriptions tight and keep must-never-miss contracts (like the continuity layer) in always-loaded AGENTS.md guidance as the backstop, not only in a skill.

## Body

- Keep `SKILL.md` under 500 lines and roughly 5,000 tokens. Move detail to `references/` and say exactly when to load each file ("read `references/api-errors.md` if the API returns a non-200"), not just "see references".
- Keep file references one level deep from `SKILL.md`. Give reference files over 100 lines a table of contents so partial reads still show the full scope.
- Add only what the model does not already know: project conventions, gotchas, exact commands. Cut anything a capable model gets right unaided.
- A "Gotchas" section of environment-specific corrections is often the highest-value content in a skill. When a correction comes up in real use, add it there.
- Provide a default, not a menu. One recommended tool with an escape hatch beats four equal options.
- Favor procedures over declarations: teach how to approach the class of problems, not the answer to one instance.
- Match prescriptiveness to fragility: high freedom for judgment tasks (reviews), exact commands for fragile sequences (migrations). Calibrate per section, not per skill.
- For multi-step work, use checklists and validation loops (do, validate, fix, repeat). For batch or destructive operations, use plan-validate-execute with a machine-checkable intermediate file.
- If a skill mentions decisions, blockers, handoffs, closeout, reports, or memory, add an explicit `Workflow Coordination` section that links to the existing owner: `vincent-workflow` for durable task state, `codex-closeout` for final chat delivery, `codex-html-report` for durable reader-facing proof, and `second-brain-context` for shared local-brain writeback. `scripts/check-drift.sh` runs the all-skill workflow-link check, and `python3 scripts/check-workflow-links.py --template` prints the standard section.
- No time-sensitive content in the main body; park deprecated behavior in an "old patterns" block.
- Bundle a script when agents keep reinventing the same logic across runs. Scripts should handle their own errors, document their constants, and the skill must say whether to execute the script or read it as reference.

## Evaluation lifecycle

- Build evals before writing extensive content: capture the failure first, then write the minimum skill that fixes it.
- Test triggering with prompts that should fire AND prompts that should route elsewhere (this library's `evals/trigger-matrix.md`).
- Run 3 to 5 trials per prompt; agent output is nondeterministic, so judge the distribution, not a single run.
- Test with every model tier the skill will run on; what works for a frontier model may underspecify for a small one.
- Periodically run the eval without the skill. If the bare model passes, the model has absorbed the skill's value: retire it.
- Read execution traces, not just outcomes. Wasted steps usually mean vague instructions, instructions that misfire on the current task, or option overload.

## How this library maps

Already aligned: what-plus-when descriptions, "Do not use when" routing, `references/` progressive disclosure, bundled scripts with usage notes, the trigger matrix, and concise bodies (all under 500 lines as of this audit).

Adopted from this review:

- Persona-style descriptions are banned; prefer capability and routing boundaries over roleplay labels.
- The trigger matrix now states the 3-to-5-trial expectation.
- Retirement rule: when touching a skill, ask whether the bare model now handles its core case; if yes, propose retiring it instead of polishing it.

Worth adopting when skills are next touched, not as a sweep:

- Add "Gotchas" sections to the ops skills as corrections accumulate.
- Add a table of contents to reference files over 100 lines (for example `kubernetes-reference.md`).
- Make load conditions explicit on `references/` pointers ("read X when Y"), where they currently just say "see X".
