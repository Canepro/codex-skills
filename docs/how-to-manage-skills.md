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

- `aks-gitops-pvc-rightsize`
- `anti-ai-writing`
- `codex-app-server-backend-adapter`
- `codex-html-report`
- `codex-mcp-repair`
- `entra-oidc-app-integration`
- `gitops-reconcile`
- `jenkins-sre`
- `k8s-sre-triage`
- `kubernetes-platform-architecture`
- `last30days`
- `loki`
- `loki-label-analyzer`
- `m365-admin`
- `n8n-workflow-api-deploy`
- `playwright`
- `prometheus-cardinality-troubleshooter`
- `prometheus-grafana-triage`
- `prometheus-label-strategy`
- `screenshot`
- `security-ownership-map`
- `terraform-skill`
- `transcribe`
- `vendor-security-gitops-patch`
- `zoho-desk-api-notes`

Pinned system skills expected from Codex as of this commit:

- `imagegen`
- `openai-docs`
- `plugin-creator`
- `review-agent`
- `skill-creator`
- `skill-installer`

## Normal refresh flow

Run this on an existing machine:

```bash
bash ~/src/codex-skills/scripts/bootstrap.sh
```

That will:

1. pull the latest repo
2. install library-managed skills into `~/.agents/skills`, `~/.cursor/skills`, and `~/.claude/skills`; Codex discovers the shared `~/.agents/skills` root directly
3. sync non-repo installed entries from the canonical Agents tree to Claude
4. verify library-managed drift and the pinned system-skill contract

## New machine bootstrap

```bash
gh auth login
gh repo clone Canepro/codex-skills ~/src/codex-skills
bash ~/src/codex-skills/scripts/bootstrap.sh
```

The drift check enforces the pinned system-skill contract under `~/.agents/skills/.system`. This repo currently pins the six system skills in `system-skills.lock`: `imagegen`, `openai-docs`, `plugin-creator`, `review-agent`, `skill-creator`, and `skill-installer`.

If `check-drift.sh` fails on the enforced `agents-system` section after an intentional Codex upgrade, inspect the change first. Only then refresh the lock intentionally:

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
4. Keep the skill focused on its domain. Do not add generic planning, closeout,
   prose, memory, or continuity routing that the agent runtime already owns.
   Link another skill only when it supplies a required capability for a real
   branch of this skill.

5. Install and validate:

```bash
cd ~/src/codex-skills
bash scripts/install.sh
bash scripts/check-drift.sh
```

6. Commit and push:

```bash
git status
git add .
git commit -m "Add <skill-name> skill"
git push origin main
```

## Promoting a local extra into the repo

If you notice a useful skill exists only in `~/.agents/skills`, do not leave it there if it is meant to be durable.

1. Copy its contents into `skills/<skill-name>/` in this repo.
2. Install from the repo.
3. Run `bash scripts/check-drift.sh`.
4. Commit and push.

This is how a local portable candidate becomes library-managed.

Local, private, product-specific, or machine-specific skills can stay out of this repo on purpose. Keep them as plain skill directories in `~/.agents/skills/<skill-name>` and let `sync-installed-extras.sh --sync` mirror them to the Claude tree. Vendor-owned skill directories may link to their canonical checkout, and the sync check follows those links. Do NOT add private skills to any `.codex-skills-managed` manifest: the manifest is install bookkeeping for repo-managed skills only, and `install.sh` uninstalls manifest entries that left the repo. Discovery comes from the directory itself, so unmanaged directories are preserved and discoverable. To keep a private skill out of Claude Code, list its name in `~/.claude/skills/.codex-skills-claude-exclude`.

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
- `manifest entries from local extras`: should normally be empty; private skills do not belong in manifests
- `external or preserved installed skills`: entries not managed by this repo, including private skills
- `pinned system skills aligned`: the canonical `.agents/skills/.system` tree matches `system-skills.lock`
- `agents`: `~/.agents/skills` is the canonical user-skill root for Codex and shared agent tooling

If non-repo entries differ between the installed trees, run:

```bash
bash ~/src/codex-skills/scripts/sync-installed-extras.sh --sync
```

This mirrors private skills one way from `~/.agents/skills` into `~/.claude/skills` so Claude Code discovers them too. Claude-only externals are left alone, and skills listed in `~/.claude/skills/.codex-skills-claude-exclude` are skipped and removed from the Claude tree if present.

## Rules to avoid drift again

- Edit skills in a real checkout of this repo, not directly in installed trees.
- If a skill should survive machine rebuilds or be shared publicly, it belongs in this repo.
- If a skill is intentionally local, keep its canonical copy under `~/.agents/skills`, mirror it with `sync-installed-extras.sh --sync`, and keep it out of the manifests instead of promoting it by accident.
- If a skill is vendored from an upstream author, preserve its upstream
  `SKILL.md` wording and route around it in local docs or wrapper skills.
- Treat local installed trees as outputs, not the source of truth. `~/.claude/skills/<skill-name>/` directories are installed from the repo just like the Codex, agents, and Cursor trees.
- Do not refresh `system-skills.lock` casually; only do it after an intentional Codex upgrade review.
- After meaningful changes: install, check drift, commit, push. Run the optional backup helper only when you maintain a local mirror.
