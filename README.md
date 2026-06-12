# codex-skills

Portable skills for AI coding agents.

This repo contains reusable skills for engineering, support, platform operations, product planning, frontend review, debugging, and written communication. The skills are intended to work across agent surfaces such as Cursor, Claude Cowork, Claude Code, and Codex.

Rocket.Chat-specific ticket orchestration, customer data, private workflows, credentials, and machine-local agent state do not belong here. Keep those in the private or product repo that owns them.

## Use It

The easiest setup path is to ask your agent:

```text
Set up the skills from https://github.com/Canepro/codex-skills for this environment.
```

If you want to install manually:

```bash
gh repo clone Canepro/codex-skills ~/src/codex-skills
bash ~/src/codex-skills/scripts/bootstrap.sh
```

Restart your agent after installing so it can pick up the skills. Cursor reads from `~/.cursor/skills/`; Codex and Claude Code use their own install paths (see [docs/how-to-manage-skills.md](docs/how-to-manage-skills.md)).

## What Is Included

- Planning and product: `write-a-prd`, `prd-to-plan`, `prd-to-issues`, `request-refactor-plan`, `design-an-interface`, `improve-codebase-architecture`, `grill-me`
- Frontend review and delivery: `frontend-anti-slop`, `responsive-design`, `webapp-testing`, `react-performance-review`, `design-system-maintenance`, `playwright`
- CI and GitHub workflow: `ci-pipeline-triage`, `gh-address-comments`, `setup-pre-commit`
- Security and adversary-informed defense: `adversary-informed-defense`, `security-best-practices`, `security-ownership-map`
- Kubernetes and platform: `k8s-sre-triage`, `kubernetes-platform-architecture`, `gitops-reconcile`, `gitops-workflow`, `jenkins-sre`
- Observability and reliability: `prometheus-grafana-triage`, `promql`, `loki`, `alerting-irm`, `prometheus-cardinality-troubleshooter`, `prometheus-label-strategy`, `loki-label-analyzer`, `assistant-mcp`, `observability-architecture`, `slo-sli-design`, `sentry`
- Support and operations: `l2-l3-support-platform`, `m365-admin`, `azure-infra-engineer`, `log-analyzer`, `systematic-debugging`, `written-communication`, `anti-ai-writing`
- Documents, media, and reports: `doc`, `codex-html-report`, `pdf`, `screenshot`, `transcribe`, `hatch-pet`
- Tooling, migration, and testing: `cli-creator`, `migrate-to-codex`, `tdd`, `triage-issue`
- Naming, discovery, and handoff: `naming-quality`, `find-skills`, `codex-closeout`

Skills end with a "Workflow Coordination" section that may name local coordination skills (for example `vincent-workflow` or `second-brain-context`) which are not part of this repo. If you do not have them installed, agents ignore those references; the skills work standalone.

## Maintainers

Maintenance details live in [docs/how-to-manage-skills.md](docs/how-to-manage-skills.md).

Skills are checked for workflow coordination during drift validation. If a
skill introduces decisions, blockers, handoffs, closeout, reports, or memory
behavior, route that state to the existing workflow owners instead of creating
a parallel mechanism.

Unless a nested skill directory says otherwise, this repository is licensed under Apache-2.0. Some bundled skills include their own `LICENSE.txt` or `NOTICE.txt` files; keep those files with the relevant skill when copying or redistributing it.
