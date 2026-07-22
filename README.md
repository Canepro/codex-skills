# codex-skills

Portable skills for AI coding agents.

This repo contains reusable skills for engineering, support, platform
operations, frontend review overlays, debugging, and artifact production. The
skills are intended to work across agent surfaces such as Cursor, Claude
Cowork, Claude Code, and Codex.

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

- Current research: `last30days`
- Frontend review overlays: `frontend-anti-slop`, `playwright`. Prefer installed vendor plugins for new frontend builds, product-design audits, rendered UI testing/debugging, responsive-only repair, React/Next performance, shadcn work, and web data visualization design/build/testing/export.
- CI workflow: `ci-pipeline-triage`, `codex-mcp-repair`, `codex-app-server-backend-adapter`. Prefer the installed GitHub plugin for PR comments and GitHub-native work.
- Security ownership: `security-ownership-map`. Prefer the installed Codex
  Security plugin for scans, findings, validation, threat modeling, attack-path
  analysis, and framework security review.
- Kubernetes and platform: `k8s-sre-triage`, `kubernetes-platform-architecture`, `gitops-reconcile`, `jenkins-sre`, `aks-gitops-pvc-rightsize`, `vendor-security-gitops-patch`
- Observability and reliability: `prometheus-grafana-triage`, `loki`, `prometheus-cardinality-troubleshooter`, `prometheus-label-strategy`, `loki-label-analyzer`. Prefer the installed Sentry plugin for Sentry issues and events.
- Support and operations: `l2-l3-support-platform`, `m365-admin`,
  `anti-ai-writing`, `n8n-workflow-api-deploy`, `zoho-desk-api-notes`. Prefer
  the installed Azure plugin for Azure infrastructure and identity work.
- Documents, media, and reports: `codex-html-report`, `screenshot`, `transcribe`. Prefer OpenAI primary runtime document/PDF skills for DOCX and PDF work.
- Tooling and testing: `cli-creator`, `terraform-skill`, `entra-oidc-app-integration`. Prefer installed Superpowers skills for TDD and systematic debugging.

## Maintainers

Maintenance details live in [docs/how-to-manage-skills.md](docs/how-to-manage-skills.md).

Skills are checked for valid structure and installed drift. Portable skills do
not prescribe generic planning, closeout, prose, or continuity layers; each
agent runtime and repository owns those defaults.

Unless a nested skill directory says otherwise, this repository is licensed under Apache-2.0. Some bundled skills include their own `LICENSE.txt` or `NOTICE.txt` files; keep those files with the relevant skill when copying or redistributing it.
