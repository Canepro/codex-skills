---
name: skill-library
description: Route to the portable codex-skills library installed globally. Use when choosing a skill, refreshing installs, or checking drift.
---

# Skill Library Router

Source repo: [Canepro/codex-skills](https://github.com/Canepro/codex-skills) at `~/src/codex-skills`

Global installs (after bootstrap):

- Cursor: `~/.cursor/skills/<skill-name>/SKILL.md`
- Codex: `~/.codex/skills/<skill-name>/SKILL.md`
- Claude Code: `~/.claude/skills/<skill-name>.md`

Refresh:

```bash
bash ~/src/codex-skills/scripts/bootstrap.sh
```

Check drift:

```bash
bash ~/src/codex-skills/scripts/check-drift.sh
```

## Common routing

| Task | Skill |
|------|-------|
| Copy polish; remove AI tone | `anti-ai-writing` |
| UI feels templated or generic | `frontend-uncodixfy` |
| Pre-ship UX audit | `frontend-review` |
| Mobile/responsive layout | `responsive-design` |
| Browser verification | `webapp-testing` or `playwright` |
| Design tokens / UI drift | `design-system-maintenance` |
| GitHub Actions CI red | `gh-fix-ci` |
| PR review threads | `gh-address-comments` |
| Jenkins / pipeline failures | `ci-pipeline-triage` |
| Commit hooks | `setup-pre-commit` |
| Delivery summary | `codex-closeout` |
| Find or install skills | `find-skills` |
| Customer-safe prose | `written-communication` |
| Kubernetes incidents | `k8s-sre-triage` |
| GitOps sync issues | `gitops-reconcile` |

Read the target skill's full `SKILL.md` before acting. Product-specific private workflows stay in their owning repos, not this library.
