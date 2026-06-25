# codex-skills

Portable skills for AI coding agents.

This repo contains reusable skills for engineering, support, platform operations, product planning, frontend review overlays, debugging, and written communication. The skills are intended to work across agent surfaces such as Cursor, Claude Cowork, Claude Code, and Codex.

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

- Planning and product: `write-a-prd`, `prd-to-plan`, `prd-to-issues`, `agent-plan-backlog`, `request-refactor-plan`, `design-an-interface`, `improve-codebase-architecture`, `grill-with-docs`, `last30days`
- Frontend review overlays: `frontend-anti-slop`, `design-system-maintenance`, `playwright`. Prefer installed vendor plugins for new frontend builds, product-design audits, rendered UI testing/debugging, responsive-only repair, React/Next performance, shadcn work, and web data visualization design/build/testing/export.
- CI workflow: `ci-pipeline-triage`, `setup-pre-commit`. Prefer the installed GitHub plugin for PR comments and GitHub-native work.
- Security and adversary-informed defense: `adversary-informed-defense`, `security-ownership-map`. Prefer the installed Codex Security plugin for scans, findings, validation, and framework security review.
- Kubernetes and platform: `k8s-sre-triage`, `kubernetes-platform-architecture`, `gitops-reconcile`, `gitops-workflow`, `jenkins-sre`
- Observability and reliability: `prometheus-grafana-triage`, `promql`, `loki`, `alerting-irm`, `prometheus-cardinality-troubleshooter`, `prometheus-label-strategy`, `loki-label-analyzer`, `assistant-mcp`, `observability-architecture`, `slo-sli-design`. Prefer the installed Sentry plugin for Sentry issues and events.
- Support and operations: `l2-l3-support-platform`, `m365-admin`, `log-analyzer`, `written-communication`, `anti-ai-writing`. Prefer the installed Azure plugin for Azure infrastructure and identity work.
- Documents, media, and reports: `codex-html-report`, `screenshot`, `transcribe`, `hatch-pet`. Prefer OpenAI primary runtime document/PDF skills for DOCX and PDF work.
- Tooling, migration, and testing: `cli-creator`, `migrate-to-codex`, `triage-issue`. Prefer installed Superpowers skills for TDD and systematic debugging.
- Naming, discovery, and handoff: `naming-quality`, `find-skills`, `codex-closeout`

## Workflow Coordination References

Skills end with a "Workflow Coordination" section that may name local coordination skills (for example `vincent-workflow` or `second-brain-context`) which are not part of this repo. If you do not have them installed, agents ignore those references; the skills work standalone.

## Maintainers

Maintenance details live in [docs/how-to-manage-skills.md](docs/how-to-manage-skills.md).

Skills are checked for workflow coordination during drift validation. If a
skill introduces decisions, blockers, handoffs, closeout, reports, or memory
behavior, route that state to the existing workflow owners instead of creating
a parallel mechanism.

Unless a nested skill directory says otherwise, this repository is licensed under Apache-2.0. Some bundled skills include their own `LICENSE.txt` or `NOTICE.txt` files; keep those files with the relevant skill when copying or redistributing it.
