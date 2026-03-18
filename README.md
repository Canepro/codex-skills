# codex-skills

Portable Codex skill pack for this workspace owner.

## Source of truth

- Canonical repo: `~/src/codex-skills`
- Backup mirror: `/mnt/d/repos/codex-skills`

Edit and commit only in the canonical repo. Treat the D drive copy as a backup.

## Layout

- `skills/`: skill folders synced into `~/.codex/skills`
- `scripts/install.sh`: sync this repo into the local Codex skills directory
- `scripts/bootstrap.sh`: clone or pull the GitHub repo, then install the skills
- `scripts/backup-to-drive.sh`: mirror the canonical repo into `/mnt/d/repos/codex-skills`

## One-command refresh on a machine that already has the repo

```bash
bash ~/src/codex-skills/scripts/bootstrap.sh
```

## One-command setup on a new machine

Prereq: `gh auth login`

```bash
bash -lc 'mkdir -p ~/src && if [ -d ~/src/codex-skills/.git ]; then git -C ~/src/codex-skills pull --ff-only; else gh repo clone Canepro/codex-skills ~/src/codex-skills; fi && bash ~/src/codex-skills/scripts/install.sh'
```

## Refresh the backup mirror

```bash
bash scripts/backup-to-drive.sh
```
