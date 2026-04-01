# codex-skills

Portable Codex skill pack for this workspace owner.

## What this repo is

This repo is the source of truth for your reusable Codex skills.

- Canonical working repo: `~/src/codex-skills`
- Backup mirror: `/mnt/d/repos/codex-skills`
- GitHub remote: `Canepro/codex-skills`

Edit and commit only in the canonical repo. Treat the D drive copy as a backup.

## Repo layout

- `skills/`: skill folders that get synced into the local Codex skill directories
- `scripts/install.sh`: installs this repo's skills into the local Codex skill directory
- `scripts/bootstrap.sh`: pulls the repo if it already exists locally, then installs the skills
- `scripts/check-drift.sh`: compares repo skills, managed manifests, and installed skill directories
- `scripts/backup-to-drive.sh`: mirrors the canonical repo into `/mnt/d/repos/codex-skills`
- `scripts/sync-installed-extras.sh`: syncs preserved non-repo skill directories between `~/.codex/skills` and `~/.agents/skills`
- `evals/`: prompt matrices for checking trigger quality and overlap

## Skill map

Current pack by category:

- Planning and product: `write-a-prd`, `prd-to-plan`, `prd-to-issues`, `request-refactor-plan`, `design-an-interface`, `improve-codebase-architecture`, `grill-me`
- Frontend review and delivery: `frontend-review`, `frontend-uncodixfy`, `responsive-design`, `webapp-testing`, `react-performance-review`, `design-system-maintenance`, `playwright`
- CI and GitHub workflow: `ci-pipeline-triage`, `gh-fix-ci`, `gh-address-comments`, `setup-pre-commit`
- Kubernetes and platform: `k8s-sre-triage`, `kubernetes-platform-architecture`, `gitops-reconcile`, `gitops-workflow`, `jenkins-sre`
- Observability and reliability: `prometheus-grafana-triage`, `observability-architecture`, `slo-sli-design`, `sentry`
- Documents and testing workflow: `doc`, `tdd`, `triage-issue`
- Delivery and handoff: `codex-closeout`
- Support and operations: `l2-l3-support-platform`
- Naming and terminology: `naming-quality`

Useful adjacency rules:

- `frontend-review` diagnoses; `frontend-uncodixfy` redesigns.
- `responsive-design` fixes layout adaptation; `webapp-testing` verifies user flows.
- `playwright` drives the browser; `webapp-testing` decides what evidence to collect.
- `k8s-sre-triage` handles live incidents; `kubernetes-platform-architecture` handles platform design.
- `gitops-reconcile` fixes a broken sync; `gitops-workflow` designs the GitOps operating model.
- `prometheus-grafana-triage` handles alerting incidents; `observability-architecture` and `slo-sli-design` handle durable telemetry and reliability design.
- `l2-l3-support-platform` handles Microsoft 365, Entra, and Rocket.Chat support investigation, supported-guidance checks, and customer-ready case communication.

## Daily use

If this machine already has the repo, this is the main command to remember:

```bash
bash ~/src/codex-skills/scripts/bootstrap.sh
```

What it does:
- pulls the latest `main`
- installs repo-managed skills into `~/.codex/skills` and `~/.agents/skills`
- syncs preserved local extras between the two installed skill trees
- runs the repo drift check
- preserves non-repo content such as preinstalled/system skill entries

After running it, restart Codex if you want the updated skills picked up immediately.

## First-time setup on a new machine

Prerequisite:

```bash
gh auth login
```

Then run:

```bash
gh repo clone Canepro/codex-skills ~/src/codex-skills && bash ~/src/codex-skills/scripts/bootstrap.sh
```

That gives you the repo locally and installs the skills in one go.

## Install without pulling

If you are already inside the repo and only want to reinstall the current local version of the skills:

```bash
bash scripts/install.sh
```

## Verify drift

To check whether the repo, the managed manifests, and the installed skill directories still agree:

```bash
bash ~/src/codex-skills/scripts/check-drift.sh
```

The script reports repo-managed drift as an error, flags installed-tree mismatches directly, and lists preserved external entries separately so you can tell the difference between expected extras and actual mismatch.

To sync preserved non-repo extras between `~/.codex/skills` and `~/.agents/skills`:

```bash
bash ~/src/codex-skills/scripts/sync-installed-extras.sh --sync
```

## Backup refresh

To refresh the D drive backup mirror from the canonical repo:

```bash
bash ~/src/codex-skills/scripts/backup-to-drive.sh
```

## Update workflow

When you change skills in the canonical repo, the normal flow is:

```bash
cd ~/src/codex-skills
bash scripts/install.sh
bash scripts/sync-installed-extras.sh --sync
bash scripts/check-drift.sh
bash scripts/backup-to-drive.sh
git status
```

Then commit and push when ready.

## Add a new skill

1. Create a new folder under `skills/`.
2. Add a `SKILL.md` file with YAML frontmatter and clear trigger text.
3. Optionally add:
   - `agents/openai.yaml` for UI metadata
   - `references/` for material the agent may read on demand
   - `scripts/` for helper scripts
   - `assets/` for icons, templates, or other output files
4. Install locally:

```bash
bash scripts/install.sh
```

5. Restart Codex and try the skill.
6. Refresh the backup mirror:

```bash
bash scripts/backup-to-drive.sh
```

7. Commit and push.

## Minimal skill template

```md
---
name: my-skill
description: Clear description of when to use this skill and what it helps with.
---

# My Skill

Short, direct instructions for how the skill should work.
```

## Optional `agents/openai.yaml`

Use this when you want better UI labels and a default prompt.

Example:

```yaml
interface:
  display_name: "My Skill"
  short_description: "Short UI description here"
  default_prompt: "Use $my-skill to help with ..."
```

## Good habits

- Keep `SKILL.md` concise and specific.
- Put detailed material in `references/` instead of bloating `SKILL.md`.
- Keep scripts deterministic when a task is repetitive or fragile.
- Edit only in `~/src/codex-skills`, not in the D drive mirror.
- Treat `scripts/bootstrap.sh` as the normal refresh command.
- Use `scripts/check-drift.sh` after installs or remote updates when you want a quick consistency check.
- Test trigger quality after adding or splitting adjacent skills.
- The installer only manages skills that exist in this repo. It does not delete unrelated skill folders outside its manifest.
- Use `scripts/sync-installed-extras.sh` when preserved extras need to stay aligned between the two installed skill trees.

## Trigger evaluation

Use `evals/trigger-matrix.md` when the taxonomy changes.

Recommended loop:

1. Install the current repo with `bash scripts/install.sh`.
2. Restart Codex.
3. Start a fresh prompt with one matrix example at a time.
4. Confirm the intended skill triggers and nearby skills do not.
5. Tighten frontmatter or `Do not use when` sections where the routing is weak.

## Quick memory version

- Existing machine: `bash ~/src/codex-skills/scripts/bootstrap.sh`
- Verify state: `bash ~/src/codex-skills/scripts/check-drift.sh`
- Sync preserved extras: `bash ~/src/codex-skills/scripts/sync-installed-extras.sh --sync`
- New machine: `gh repo clone Canepro/codex-skills ~/src/codex-skills && bash ~/src/codex-skills/scripts/bootstrap.sh`
- Backup mirror: `bash ~/src/codex-skills/scripts/backup-to-drive.sh`
- After skill changes: run install, then restart Codex
