#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="$REPO_DIR/skills"
DEST_DIR="${CODEX_HOME:-$HOME/.codex}/skills"

mkdir -p "$DEST_DIR"

if command -v rsync >/dev/null 2>&1; then
  rsync -a --delete "$SRC_DIR/" "$DEST_DIR/"
else
  find "$DEST_DIR" -mindepth 1 -maxdepth 1 -type d -exec rm -rf {} +
  cp -a "$SRC_DIR/." "$DEST_DIR/"
fi

printf 'Installed skills into %s\n' "$DEST_DIR"
printf 'Restart Codex to pick up skill changes.\n'
