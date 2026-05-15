#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="${CODEX_SKILLS_BACKUP_DIR:-$HOME/src/codex-skills-backups/codex-skills}"

mkdir -p "$BACKUP_DIR"
rsync -a --delete "$REPO_DIR/" "$BACKUP_DIR/"

printf 'Backed up %s to %s\n' "$REPO_DIR" "$BACKUP_DIR"
