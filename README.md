# codex-skills

Portable Codex skill pack for this workspace owner.

## Source of truth

- Canonical repo: `~/src/codex-skills`
- Backup mirror: `/mnt/d/repos/codex-skills`

Edit and commit only in the canonical repo. Treat the D drive copy as a backup.

## Layout

- `skills/`: skill folders synced into `~/.codex/skills`
- `scripts/install.sh`: sync this repo into the local Codex skills directory
- `scripts/backup-to-drive.sh`: mirror the canonical repo into `/mnt/d/repos/codex-skills`

## Install on a machine

```bash
bash scripts/install.sh
```

This syncs the repo's `skills/` directory into `${CODEX_HOME:-$HOME/.codex}/skills`.

After installing, restart Codex.

## Refresh the backup mirror

```bash
bash scripts/backup-to-drive.sh
```
