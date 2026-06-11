# How To Manage This Skill Repo

This is the maintenance guide for the reusable agent skill library.

## Current contract

This repo owns two things:

- every library-managed portable skill under `skills/`
- the pinned `system-skills.lock` contract for Codex-provided `.system` skills

If a reusable skill should survive machine rebuilds or be shared across agent surfaces such as Claude Cowork, Claude Code, and Codex, it belongs in this repo. Product-specific orchestration, private support workflows, customer data, ticket exports, credentials, and machine-local agent state belong in their owning private or product repo.

To print the current list directly from repo state instead of reading this doc, run:

```bash
bash ~/src/codex-skills/scripts/list-skills.sh
```

## Current available skills

Library-managed skills as of this commit:

- `anti-ai-writing`
- `adversary-informed-defense`
- `alerting-irm`
- `assistant-mcp`
- `azure-infra-engineer`
- `ci-pipeline-triage`
- `cli-creator`
- `codex-html-report`
- `codex-closeout`
- `design-an-interface`
- `design-system-maintenance`
- `doc`
- `find-skills`
- `frontend-anti-slop`
- `gh-address-comments`
- `gitops-reconcile`
- `gitops-workflow`
- `grill-me`
- `hatch-pet`
- `improve-codebase-architecture`
- `jenkins-sre`
- `k8s-sre-triage`
- `kubernetes-platform-architecture`
- `l2-l3-support-platform`
- `log-analyzer`
- `loki`
- `loki-label-analyzer`
- `m365-admin`
- `migrate-to-codex`
- `naming-quality`
- `observability-architecture`
- `playwright`
- `pdf`
- `prd-to-issues`
- `prd-to-plan`
- `prometheus-cardinality-troubleshooter`
- `prometheus-grafana-triage`
- `prometheus-label-strategy`
- `promql`
- `react-performance-review`
- `request-refactor-plan`
- `responsive-design`
- `sentry`
- `screenshot`
- `security-best-practices`
- `security-ownership-map`
- `setup-pre-commit`
- `slo-sli-design`
- `systematic-debugging`
- `tdd`
- `triage-issue`
- `transcribe`
- `webapp-testing`
- `write-a-prd`
- `written-communication`

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
2. install library-managed skills into `~/.codex/skills`, `~/.agents/skills`, `~/.cursor/skills`, and `~/.claude/skills`
3. sync non-repo installed entries between the two trees
4. verify library-managed drift and the pinned system-skill contract

## New machine bootstrap

```bash
gh auth login
gh repo clone Canepro/codex-skills ~/src/codex-skills
bash ~/src/codex-skills/scripts/bootstrap.sh
```

Codex 0.139 and later no longer materialize `~/.codex/skills/.system`; the drift check reports an absent system directory as a note, not a failure. The pinned contract still applies wherever a `.system` directory exists (for example the preserved copy under `~/.agents/skills/.system`).

If `check-drift.sh` fails on the system-skill section after an intentional Codex upgrade, inspect the change first. Only then refresh the lock intentionally:

```bash
cd ~/src/codex-skills
bash scripts/system-skill-lock.sh --write
bash scripts/check-drift.sh
```

Commit the updated lock if the new system contract is the one you want to standardize.

## Adding a new durable skill

Use this when the skill should be available across machines or compatible agent surfaces.

1. Create `skills/<skill-name>/SKILL.md`.
2. Add `agents/openai.yaml` if the skill should have a polished UI label or default prompt.
3. Keep the skill concise; put detailed references in `references/` only when needed.
4. Install and validate:

```bash
cd ~/src/codex-skills
bash scripts/install.sh
bash scripts/check-drift.sh
```

5. Commit and push:

```bash
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

This is how `find-skills` and `naming-quality` were normalized.

## Skillforge lifecycle convention

Commits prefixed `skillforge:` record the external skillforge eval loop. They do not install, uninstall, or move skills:

- `skillforge: promoted <skill>` means the skill passed its benchmark and is endorsed as-is.
- `skillforge: quarantined <skill>` means the eval flagged a behavior. The commit adds guardrails inside the skill itself, such as a consent-and-pause workflow step or a "SkillForge Validation Notes" section listing protected invariants. The skill stays installed and active.

When editing a quarantined skill, preserve the added guard sections and the behaviors its validation notes protect.

## Drift triage

Run:

```bash
bash ~/src/codex-skills/scripts/check-drift.sh
```

Interpretation:

- `library-managed skills aligned`: repo content, manifests, and installs match
- `external or preserved installed skills`: entries not managed by this repo
- `pinned system skills aligned`: `.system` matches `system-skills.lock`
- `installed-tree-alignment`: `~/.codex/skills` and `~/.agents/skills` expose the same top-level directories

If non-repo entries differ between the two installed trees, run:

```bash
bash ~/src/codex-skills/scripts/sync-installed-extras.sh --sync
```

## Rules to avoid drift again

- Edit skills in a real checkout of this repo, not directly in installed trees.
- If a skill should survive machine rebuilds or be shared publicly, it belongs in this repo.
- Treat local installed trees as outputs, not the source of truth. `~/.claude/skills/*.md` files are generated from each repo skill's `SKILL.md`.
- Do not refresh `system-skills.lock` casually; only do it after an intentional Codex upgrade review.
- After meaningful changes: install, check drift, commit, push. Run the optional backup helper only when you maintain a local mirror.
