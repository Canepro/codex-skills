# How To Manage This Skill Repo

This is the authoritative repo for the owner's repeatable Codex skill environment.

## Current contract

This repo owns two things:

- every owner-managed skill under `skills/`
- the pinned `system-skills.lock` contract for Codex-provided `.system` skills

If a skill matters on every machine, it belongs in this repo. Do not leave durable skills as ad hoc local extras.

To print the current list directly from repo state instead of reading this doc, run:

```bash
bash ~/src/codex-skills/scripts/list-skills.sh
```

## Current available skills

Repo-managed skills as of this commit:

- `ci-pipeline-triage`
- `codex-closeout`
- `design-an-interface`
- `design-system-maintenance`
- `dev-browser`
- `doc`
- `find-skills`
- `frontend-review`
- `frontend-uncodixfy`
- `gh-address-comments`
- `gh-fix-ci`
- `gitops-reconcile`
- `gitops-workflow`
- `grill-me`
- `improve-codebase-architecture`
- `jenkins-sre`
- `k8s-sre-triage`
- `kubernetes-platform-architecture`
- `l2-l3-support-platform`
- `naming-quality`
- `observability-architecture`
- `playwright`
- `prd-to-issues`
- `prd-to-plan`
- `prometheus-grafana-triage`
- `react-performance-review`
- `request-refactor-plan`
- `responsive-design`
- `sentry`
- `setup-pre-commit`
- `slo-sli-design`
- `tdd`
- `triage-issue`
- `webapp-testing`
- `write-a-prd`

Pinned system skills expected from Codex as of this commit:

- `imagegen`
- `openai-docs`
- `plugin-creator`
- `skill-creator`
- `skill-installer`

## Normal refresh flow

Run this on an existing machine:

```bash
bash ~/src/codex-skills/scripts/bootstrap.sh
```

That will:

1. pull the latest repo
2. install repo-managed skills into `~/.codex/skills` and `~/.agents/skills`
3. sync non-repo installed entries between the two trees
4. verify repo-managed drift and the pinned system-skill contract

## New machine bootstrap

```bash
gh auth login
gh repo clone Canepro/codex-skills ~/src/codex-skills
bash ~/src/codex-skills/scripts/bootstrap.sh
```

If `check-drift.sh` fails on the system-skill section after an intentional Codex upgrade, inspect the change first. Only then refresh the lock intentionally:

```bash
cd ~/src/codex-skills
bash scripts/system-skill-lock.sh --write
bash scripts/check-drift.sh
```

Commit the updated lock if the new system contract is the one you want to standardize.

## Adding a new durable skill

Use this when the skill should exist on every machine.

1. Create `skills/<skill-name>/SKILL.md`.
2. Add `agents/openai.yaml` if the skill should have a polished UI label or default prompt.
3. Keep the skill concise; put detailed references in `references/` only when needed.
4. Install and validate:

```bash
cd ~/src/codex-skills
bash scripts/install.sh
bash scripts/check-drift.sh
```

5. Refresh the backup mirror, then commit and push:

```bash
bash scripts/backup-to-drive.sh
git status
git add .
git commit -m "Add <skill-name> skill"
git push origin main
```

## Promoting a local extra into the repo

If you notice a useful skill exists only in `~/.codex/skills` or `~/.agents/skills`, do not leave it there if it is meant to be durable.

1. Copy its contents into `skills/<skill-name>/` in this repo.
2. Install from the repo.
3. Run `bash scripts/check-drift.sh`.
4. Commit and push.

This is how `dev-browser`, `find-skills`, and `naming-quality` were normalized.

## Drift triage

Run:

```bash
bash ~/src/codex-skills/scripts/check-drift.sh
```

Interpretation:

- `repo-managed skills aligned`: repo content, manifests, and installs match
- `external or preserved installed skills`: entries not managed by this repo
- `pinned system skills aligned`: `.system` matches `system-skills.lock`
- `installed-tree-alignment`: `~/.codex/skills` and `~/.agents/skills` expose the same top-level directories

If non-repo entries differ between the two installed trees, run:

```bash
bash ~/src/codex-skills/scripts/sync-installed-extras.sh --sync
```

## Rules to avoid drift again

- Edit skills in `~/src/codex-skills`, not directly in installed trees.
- If a skill should survive machine rebuilds, it belongs in this repo.
- Treat local installed trees as outputs, not the source of truth.
- Do not refresh `system-skills.lock` casually; only do it after an intentional Codex upgrade review.
- After meaningful changes: install, check drift, refresh backup, commit, push.
