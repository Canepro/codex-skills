#!/usr/bin/env bash
set -euo pipefail

REPO_SLUG="${CODEX_SKILLS_REPO:-Canepro/codex-skills}"
TARGET_DIR="${CODEX_SKILLS_DIR:-$HOME/src/codex-skills}"
TARGET_PARENT="$(dirname "$TARGET_DIR")"

mkdir -p "$TARGET_PARENT"

if [ -d "$TARGET_DIR/.git" ]; then
  git -C "$TARGET_DIR" pull --ff-only
elif [ -e "$TARGET_DIR" ]; then
  printf 'Refusing to bootstrap into existing non-git path: %s\n' "$TARGET_DIR" >&2
  exit 1
else
  gh repo clone "$REPO_SLUG" "$TARGET_DIR"
fi

bash "$TARGET_DIR/scripts/install.sh"

printf 'Bootstrap complete from %s into %s\n' "$REPO_SLUG" "$TARGET_DIR"
