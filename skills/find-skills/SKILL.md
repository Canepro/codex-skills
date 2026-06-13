---
name: find-skills
description: Helps users discover and install agent skills when they ask questions like "how do I do X", "find a skill for X", "is there a skill that can...", or express interest in extending capabilities. Also routes to the portable codex-skills library, including choosing the right installed skill, refreshing installs, and checking drift. Use this when the user is looking for functionality that might already exist as a skill.
---

# Find Skills

Use this skill when the user is really asking whether a skill already exists for the job.

## When to use

- The user asks how to do something that might map to an existing skill
- The user asks for a skill recommendation or installable capability
- The user wants to extend the agent with a reusable workflow
- The user says they wish the agent had help for a specific domain

## Workflow

1. Check the current session skill catalog first, starting with the library routing table below.
2. If a relevant local skill already exists, recommend or use that instead of installing more drift.
3. If no local skill fits, search the broader ecosystem with the Skills CLI.
4. Verify quality before recommending anything.
5. If the user wants the capability to persist across machines, promote it into the configured `codex-skills` library checkout instead of leaving it as an unmanaged local extra.

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
| UI review, audit, or anti-slop redesign | `frontend-anti-slop` |
| Mobile/responsive layout | `responsive-design` |
| Browser verification | `webapp-testing` or `playwright` |
| Design tokens / UI drift | `design-system-maintenance` |
| CI, GitHub Actions, Jenkins, or pipeline failures | `ci-pipeline-triage` |
| PR review threads | `gh-address-comments` |
| Commit hooks | `setup-pre-commit` |
| Delivery summary | `codex-closeout` |
| Durable task state, decisions, blockers, handoffs | `vincent-workflow` |
| Browser-native proof report | `codex-html-report` |
| Repeated workflow mining from memory | `memory-workflow-miner` |
| Shared local-brain query or writeback | `second-brain-context` |
| Repo queue orchestration | `maintainer-orchestrator` |
| Latest research, last-30-days trends, recent community signals, improvement techniques | `last30days` |
| Naming, renaming, terminology drift | `naming-quality` |
| Pressure-test a plan or decision | `grill-me` |
| Executor-grade plan backlog, /improve-style plans, or reconcile stale plans | `agent-plan-backlog` |
| API or module interface design | `design-an-interface` |
| Codebase architecture improvement ideas | `improve-codebase-architecture` |
| Risky refactor sequencing | `request-refactor-plan` |
| Customer-safe prose | `written-communication` |
| Word documents | `doc` |
| PDFs | `pdf` |
| Audio transcription | `transcribe` |
| Desktop screenshots | `screenshot` |
| Kubernetes incidents | `k8s-sre-triage` |
| Kubernetes platform or cluster design | `kubernetes-platform-architecture` |
| GitOps sync issues | `gitops-reconcile` |
| Azure infrastructure | `azure-infra-engineer` |
| Prometheus/Grafana alert or scrape triage | `prometheus-grafana-triage` |
| PromQL query writing or optimization | `promql` |
| Loki or LogQL work | `loki` |
| Grafana alert routing, silences, SLOs, IRM | `alerting-irm` |
| Prometheus cardinality fire | `prometheus-cardinality-troubleshooter` |
| Prometheus label strategy | `prometheus-label-strategy` |
| Loki label strategy | `loki-label-analyzer` |
| Grafana MCP setup for agents | `assistant-mcp` |
| Security best-practice review | `security-best-practices` |
| Security ownership or bus-factor map | `security-ownership-map` |
| Adversary-informed defensive planning | `adversary-informed-defense` |
| CLI creation from API docs or curls | `cli-creator` |
| Migrate Claude-style artifacts into Codex | `migrate-to-codex` |

Read the target skill's full `SKILL.md` before acting. Product-specific private workflows stay in their owning repos, not this library. Before shipping any user-visible prose, apply `anti-ai-writing`.

When the user asks to improve the skill system itself, check for an existing
coordination surface before adding a new skill. Shared workflow concerns belong
in `vincent-workflow`; final chat delivery belongs in `codex-closeout`; durable
reader artifacts belong in `codex-html-report`; cross-context memory belongs in
`second-brain-context`.

## Skills CLI

The Skills CLI is the package manager for the broader skill ecosystem.

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
- Do not recommend a skill based only on a search result title.

## Response pattern

When you find a relevant skill, tell the user:

- the skill name
- what it helps with
- where it comes from
- why it looks trustworthy
- how to install it

If the user wants it to become part of their durable agent environment, add it to the configured `codex-skills` library workflow instead of stopping at a local one-off install.

## When nothing relevant exists

If you cannot find a suitable skill:

- say that clearly
- offer to handle the task directly
- suggest creating a new skill if the workflow is worth reusing
