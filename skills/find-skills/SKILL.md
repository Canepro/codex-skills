---
name: find-skills
description: 'Helps users discover, choose, and install agent skills when they ask "how do I do X", "find a skill for X", "is there a skill that can...", or why a skill is underused, stale, missing, obsolete, or superseded. Routes to the portable codex-skills library: picking the right installed skill, refreshing installs, and checking drift.'
---

# Find Skills

Use this skill when the user is really asking whether a skill already exists for the job.

## When to use

- The user asks how to do something that might map to an existing skill
- The user asks for a skill recommendation or installable capability
- The user wants to extend the agent with a reusable workflow
- The user says they wish the agent had help for a specific domain
- The user asks about underused, stale, obsolete, missing, retired, or superseded skills
- A task is being handled manually but a plain-English route likely maps to an installed skill

## Workflow

1. Check the current session skill catalog first, starting with the library routing table below.
2. Run the essential-skill gate below before deciding the task is ordinary. This catches reviews, proof reports, closeouts, secrets, workflow continuity, and self-improvement work that should not depend on memory or habit.
3. If a relevant local skill already exists, recommend or use that instead of installing more drift.
4. Inventory active tools, connectors, plugins, installed skills, local source directories, and relevant repo scripts before saying a capability is missing. Absence from the session catalog is not proof a skill is unavailable; catalogs can truncate, so check the installed directories and source repo first.
5. If the user names an exact skill name, check that exact skill name first; if the user describes a capability, search by capability and rank close matches by best fit instead of listing unsorted results.
6. If no local skill fits, search the wider skill catalog with the Skills CLI or `tool_search` when available.
7. Verify quality before recommending anything, and do this before installing.
8. If the user wants the capability to persist across machines, promote it into the configured `codex-skills` library checkout instead of leaving it as an unmanaged local extra.

## Library routing

Source repo: [Canepro/codex-skills](https://github.com/Canepro/codex-skills) at `~/src/codex-skills`. Global installs after bootstrap:

- Cursor: `~/.cursor/skills/<skill-name>/SKILL.md`
- Codex: `~/.codex/skills/<skill-name>/SKILL.md`
- Claude Code: `~/.claude/skills/<skill-name>/SKILL.md`

Refresh installs with `bash ~/src/codex-skills/scripts/bootstrap.sh`; check drift with `bash ~/src/codex-skills/scripts/check-drift.sh`.

Common routes:

| Task | Skill |
|------|-------|
| Copy polish; remove AI tone | `anti-ai-writing` |
| New frontend app, non-analytical dashboard, website, hero, redesign, or modernization | installed vendor plugin: `build-web-apps:frontend-app-builder` |
| Product flow audit, prototype, image-to-code, URL-to-code, or design QA | installed vendor plugin: Product Design skills |
| Web data visualization, analytical dashboard, chart choice, maps, Gantt, UML/software diagrams, D3/Canvas/WebGL visualization, visualization accessibility/testing, or report/slide exports with charts | installed vendor plugin: `build-web-data-visualization:data-visualization` |
| UI review, PR audit, or anti-slop polish on an existing screen | `frontend-anti-slop` |
| Mobile/responsive layout or rendered UI debugging | installed vendor plugin: `build-web-apps:frontend-testing-debugging` |
| Browser verification | installed vendor plugin: `build-web-apps:frontend-testing-debugging`, or `playwright` for browser driving only |
| React/Next performance and rendering guidance | installed vendor plugin: `build-web-apps:react-best-practices` |
| shadcn component or registry work | installed vendor plugin: `build-web-apps:shadcn` |
| Design tokens / UI drift | `design-system-maintenance` |
| CI, GitHub Actions, Jenkins, or pipeline failures | `ci-pipeline-triage` |
| PR review threads or GitHub-native work | installed vendor plugin: GitHub skills |
| Pre-merge, risky-change, architecture, or local-tooling review gate | `mira-review-gate` |
| Delivery summary | `codex-closeout` |
| Durable task state, decisions, blockers, handoffs | `vincent-workflow` |
| Browser-native proof report | `codex-html-report` |
| Repeated workflow mining from memory | `memory-workflow-miner` |
| Shared local-brain query or writeback | `second-brain-context` |
| Repo queue orchestration | `maintainer-orchestrator` |
| Latest research, last-30-days trends, recent community signals, improvement techniques | `last30days` |
| Agent self-improvement, skill routing, underused-skill review, loop engineering | `mira-loop-engineering` |
| Pressure-test a plan or decision | `grill-with-docs` |
| Executor-grade plan backlog, /improve-style plans, reconcile stale plans, or risky refactor sequencing | `agent-plan-backlog` |
| Customer-safe prose | `written-communication` |
| Word documents | installed OpenAI primary runtime Documents skill |
| PDFs | installed OpenAI primary runtime PDF skill |
| Audio transcription | `transcribe` |
| Desktop screenshots | `screenshot` |
| Kubernetes incidents | `k8s-sre-triage` |
| Kubernetes platform or cluster design | `kubernetes-platform-architecture` |
| GitOps sync issues | `gitops-reconcile` |
| Azure infrastructure, identity, or deployment | installed Azure plugin skills |
| Prometheus/Grafana alert or scrape triage | `prometheus-grafana-triage` |
| Loki or LogQL work | `loki` |
| Prometheus cardinality fire | `prometheus-cardinality-troubleshooter` |
| Prometheus label strategy | `prometheus-label-strategy` |
| Loki label strategy | `loki-label-analyzer` |
| Sentry issues, events, or project health | installed Sentry plugin |
| Security scan, finding triage, validation, or framework security review | installed Codex Security plugin |
| Security ownership or bus-factor map | `security-ownership-map` |
| Adversary-informed defensive planning | `adversary-informed-defense` |
| Explicit TDD or red-green-refactor workflow | installed Superpowers `test-driven-development` skill |
| Unclear root cause, repeated failed fixes, or systematic debugging | installed Superpowers `systematic-debugging` skill |
| CLI creation from API docs or curls | `cli-creator` |

Read the target skill's full `SKILL.md` before acting. Product-specific private workflows stay in their owning repos, not this library. Before shipping any user-visible prose, apply `anti-ai-writing`.

Maintenance rule: when a skill is retired, quarantined, or renamed, verify its row in this table in the same change.

## Essential-skill gate

Use this gate whenever the task is non-trivial, durable, risky, user-facing, or
about the agent's own workflow. It is a quick routing check, not a new process layer.

| Tier | Trigger | Required skill route |
|------|---------|----------------------|
| T0 authority and safety | Secrets, credentials, tokens, private keys, consent, final submission, destructive cleanup, live infra, billing, public posting, production deploy, global hooks | Use the exact domain skill first when one exists, such as `infisical-secrets-management` for secrets, then keep the approval gate explicit. |
| T0 review | Review before merge, risky local tooling change, architecture critique, shared behavior, runtime authority, user-facing workflow, or "check this properly" | Use `mira-review-gate` before repair or closeout. |
| T0 continuity | Broad self-improvement, multi-step repo work, implementation with verification, "do not stop", repeated "set a goal", durable decisions, blockers, handoffs, commit/push/cleanup state | Use `vincent-workflow` for the workflow contract and goal/cleanup obligation. |
| T1 reader artifact | Completed-work report, proof report, infra report, research brief, architecture plan, support/ops case, or anything that should outlive chat | Use `codex-html-report` and start from `templates/report.html`. |
| T1 final delivery | Finishing implementation, reporting verification, or summarizing changed repo state | Use `codex-closeout` after the work is genuinely done. |
| T1 user-visible prose | Chat reply, docs, report text, PR body, commit message, support reply, email, or handoff text | Use `anti-ai-writing` as the final pass. |
| T2 discovery and self-improvement | Missing, stale, underused, redundant, or over-broad skills; repeated agent failure; SkillForge eval work | Use `find-skills` for routing and `mira-loop-engineering` plus SkillForge for the durable fix. |
| T3 domain owner | Rocket.Chat, platform/runtime-specific work, Azure, GitOps, browser forms, support tickets, observability, or vendor-specific surfaces | Use the domain-specific skill before a generic helper. |

If more than one route applies, use the owner skill for the domain work, then the
cross-cutting gate that changes the outcome: review gate before risky acceptance,
HTML report for durable reader proof, closeout for final chat, and
`vincent-workflow` for durable task state.

Plain-language trigger aliases:

- Use `last30days` for "what are people saying now", "latest community signal", "recent chatter", "last month research", "current agent research", "trend scan", or "what changed recently".
- Use `agent-plan-backlog` for "make this a queue for other agents", "turn these findings into plans", "split this into autonomous passes", "reconcile stale plans", or "write improve-style executor plans".
- Use `mira-loop-engineering` for "improve how the agent works", "self-improving loop", "loop engineering", "underused or overused skills", "skill routing drift", "SkillForge evals", or "why did the agent miss this".
- Use `mira-review-gate` for "review this properly", "check this diff", "pre-merge confidence", "gate this change", "architecture critique", "local tooling review", or "make sure this is safe before accepting it".
- Use `codex-html-report` for "make a durable report", "proof report", "infra report", "architecture report", "HTML report", "browser-native artifact", or "something I can read later".
- Use `codex-closeout` for "close this out", "what changed", "what passed", "commit/push status", "dirty state", or any final delivery after repo, config, automation, skill, or report work.
- Use installed vendor plugin skills first for GitHub-native work, Azure, Sentry, Codex Security, document/PDF runtime work, TDD, systematic debugging, new frontend apps, prototypes, product-design audits, visual-target builds, responsive-only UI debugging, browser UI testing, React/Next performance, shadcn work, and web data visualization design/build/testing/export.
- Use `frontend-anti-slop` for "this UI feels AI-generated", "frontend slop", "make the dashboard less generic", "UI audit", or "polish this screen" when the task is an existing screen review or anti-slop cleanup.

If a historical usage scan mentions a skill that is not installed, first check the source repo and any SkillForge retired record. Treat source-path-missing records as obsolete unless a current source directory or explicit user request says to revive them. Route to the current replacement rather than reinstalling a dead name.

When reporting discovery work, say what you checked: session catalog, installed skill directories, source repo, SkillForge retired records, active tools, connectors, plugins, and external search surfaces that were actually used. If a route was missed or unavailable, say so directly.

## Safety and authority boundaries

Skill discovery, metadata review, local catalog checks, source inspection, and redacted proof are inside normal routing. Pause for explicit approval before secret-value handling, credential movement, token reads, private key access, cookie or session import, consent-changing action, final submission, destructive cleanup, live infra mutation, billing, public posting, or tool installation that changes authority.

When a route touches project-specific local lanes, keep private persona, customer, runtime, and secret-manager boundaries explicit. Do not move or reveal private context, credentials, or secret values while recommending a skill. Name the safer owner skill and use redacted proof instead.

## Workflow Coordination

When the user asks to improve the skill system itself, check for an existing
coordination surface before adding a new skill. Shared workflow concerns belong
in `vincent-workflow`; final chat delivery belongs in `codex-closeout`; durable
reader artifacts belong in `codex-html-report`; cross-context memory belongs in
`second-brain-context`. Route domain work to its owner skill and keep this
skill as the discovery and routing layer.

## Skills CLI

The Skills CLI is the package manager for the wider skill catalog.

Useful commands:

```bash
npx skills find [query]
npx skills add <package>
npx skills check
npx skills update
```

Browse catalog listings at `https://skills.sh/`.

## Quality checks before recommending a skill

- Prefer well-known sources over unknown publishers.
- Prefer skills with meaningful adoption over barely used packages.
- Check the source repository when trust or maintenance quality is unclear.
- Inspect the skill's metadata: description, source, version, and maintenance signals.
- Check whether the candidate duplicates an existing skill; meaningful overlap means improving the incumbent, not installing a duplicate.
- Do not recommend a skill based only on a search result title.

## Response pattern

When you find a relevant skill, tell the user:

- the skill name
- what it helps with
- where it comes from
- why it looks trustworthy
- how to install it
- what you checked and any relevant misses

If the user wants it to become part of their durable agent environment, add it to the configured `codex-skills` library workflow instead of stopping at a local one-off install.

## When nothing relevant exists

If you cannot find a suitable skill:

- say that clearly
- offer to handle the task directly
- suggest creating a new skill if the workflow is worth reusing
