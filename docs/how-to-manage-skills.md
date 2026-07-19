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

- `adversary-informed-defense`
- `agent-plan-backlog`
- `aks-gitops-pvc-rightsize`
- `anti-ai-writing`
- `ci-pipeline-triage`
- `cli-creator`
- `codex-app-server-backend-adapter`
- `codex-closeout`
- `codex-html-report`
- `codex-mcp-repair`
- `entra-oidc-app-integration`
- `fable-operating-style`
- `find-skills`
- `frontend-anti-slop`
- `gitops-reconcile`
- `grill-with-docs`
- `jenkins-sre`
- `k8s-sre-triage`
- `kubernetes-platform-architecture`
- `l2-l3-support-platform`
- `last30days`
- `loki`
- `loki-label-analyzer`
- `m365-admin`
- `n8n-workflow-api-deploy`
- `playwright`
- `prd-to-issues`
- `prd-to-plan`
- `prometheus-cardinality-troubleshooter`
- `prometheus-grafana-triage`
- `prometheus-label-strategy`
- `screenshot`
- `security-ownership-map`
- `terraform-skill`
- `transcribe`
- `vendor-security-gitops-patch`
- `writing-great-skills`
- `written-communication`
- `zoho-desk-api-notes`

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

Codex materializes `~/.codex/skills/.system` lazily from the app/runtime, so the directory can be absent between runs or drift from the stable installed mirror right after an upgrade. The drift check reports Codex-tree `.system` drift as informational by default and enforces the pinned contract on `~/.agents/skills/.system`. Set `CODEX_STRICT_SYSTEM_SKILLS=1` when you intentionally want the Codex-tree `.system` check to fail the gate too. This repo currently pins the six system skills in `system-skills.lock`: `imagegen`, `openai-docs`, `plugin-creator`, `review-agent`, `skill-creator`, and `skill-installer`.

If `check-drift.sh` fails on the enforced `agents-system` section, or if `CODEX_STRICT_SYSTEM_SKILLS=1` fails on the Codex-tree system section after an intentional Codex upgrade, inspect the change first. Only then refresh the lock intentionally:

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
4. If the skill mentions decisions, blockers, handoffs, closeout, reports, or memory, add a `Workflow Coordination` section that routes durable state to the existing owner instead of inventing another ledger. Print the standard section with:

```bash
python3 scripts/check-workflow-links.py --template
```

```markdown
## Workflow Coordination

This skill owns <domain-specific work>. It does not own general workflow state.

Use `vincent-workflow` when this work creates durable decisions, blockers, resume handoffs, known issues, commit/push/cleanup obligations, or project-local follow-up state.
Use `codex-closeout` for final chat delivery.
Use `codex-html-report` for durable reader-facing proof.
Use `second-brain-context` only when the lesson should survive across repos, agents, or future local-brain retrieval.
```

5. Install and validate:

```bash
cd ~/src/codex-skills
bash scripts/install.sh
bash scripts/check-drift.sh
```

`check-drift.sh` runs `scripts/check-workflow-links.py --all`, so this is part of the normal creation gate and also protects old skills from quietly drifting. You should not need to remember it manually.

6. Commit and push:

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

This is how `find-skills` was normalized.

Local, private, product-specific, or machine-specific skills can stay out of this repo on purpose. Keep them as plain skill directories in `~/.codex/skills/<skill-name>` and let `sync-installed-extras.sh --sync` mirror them to the Agents and Claude trees. On machines where Codex scans both user roots, `~/.agents/skills` may instead be a symlink alias to `~/.codex/skills`; the sync check follows the alias and avoids advertising identical skills twice. Do NOT add private skills to any `.codex-skills-managed` manifest: the manifest is install bookkeeping for repo-managed skills only, and `install.sh` uninstalls manifest entries that left the repo. Discovery comes from the directory itself, so unmanaged directories are preserved and discoverable. To keep a private skill out of Claude Code, list its name in `~/.claude/skills/.codex-skills-claude-exclude`.

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
- `pinned system skills aligned`: the enforced `.system` tree matches `system-skills.lock`; Codex-tree `.system` drift is informational unless `CODEX_STRICT_SYSTEM_SKILLS=1` is set
- `installed-tree-alignment`: `~/.codex/skills` and `~/.agents/skills` expose the same top-level directories

If non-repo entries differ between the installed trees, run:

```bash
bash ~/src/codex-skills/scripts/sync-installed-extras.sh --sync
```

Besides reconciling `~/.codex/skills` and `~/.agents/skills`, this mirrors Codex-tree private skills one way into `~/.claude/skills` so Claude Code discovers them too. Claude-only externals are left alone, and skills listed in `~/.claude/skills/.codex-skills-claude-exclude` are skipped and removed from the Claude tree if present.

## Rules to avoid drift again

- Edit skills in a real checkout of this repo, not directly in installed trees.
- If a skill should survive machine rebuilds or be shared publicly, it belongs in this repo.
- If a skill is intentionally local, keep the installed copies mirrored with `sync-installed-extras.sh --sync` and out of the manifests instead of promoting it by accident.
- If a skill is vendored from an upstream author, preserve its upstream `SKILL.md` wording and route around it in local docs or wrapper skills. The workflow-link check skips skills with explicit upstream `repository` and `author` frontmatter.
- Treat local installed trees as outputs, not the source of truth. `~/.claude/skills/<skill-name>/` directories are installed from the repo just like the Codex, agents, and Cursor trees.
- Do not refresh `system-skills.lock` casually; only do it after an intentional Codex upgrade review.
- After meaningful changes: install, check drift, commit, push. Run the optional backup helper only when you maintain a local mirror.
