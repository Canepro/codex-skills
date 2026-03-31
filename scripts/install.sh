#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="$REPO_DIR/skills"
DEFAULT_CODEX_DIR="${CODEX_HOME:-$HOME/.codex}/skills"
DEFAULT_AGENTS_DIR="$HOME/.agents/skills"

declare -a DEST_DIRS=("$DEFAULT_CODEX_DIR" "$DEFAULT_AGENTS_DIR")

if [ -z "${TMPDIR:-}" ] || [ ! -d "${TMPDIR:-}" ]; then
  if [ -n "${TMP:-}" ] && [ -d "$TMP" ]; then
    export TMPDIR="$TMP"
  elif [ -n "${TEMP:-}" ] && [ -d "$TEMP" ]; then
    export TMPDIR="$TEMP"
  else
    export TMPDIR="$REPO_DIR/.tmp"
    mkdir -p "$TMPDIR"
  fi
fi

install_to_dest() {
  local dest_dir="$1"
  local manifest_path="$dest_dir/.codex-skills-managed"
  local manifest_tmp
  manifest_tmp="$(mktemp)"

  mkdir -p "$dest_dir"

  if [ -f "$manifest_path" ]; then
    while IFS= read -r old_skill; do
      [ -n "$old_skill" ] || continue
      [ -d "$SRC_DIR/$old_skill" ] && continue
      rm -rf "$dest_dir/$old_skill"
    done < "$manifest_path"
  fi

  : > "$manifest_tmp"

  for skill_path in "$SRC_DIR"/*; do
    [ -d "$skill_path" ] || continue
    skill_name="$(basename "$skill_path")"
    printf '%s\n' "$skill_name" >> "$manifest_tmp"

    if command -v rsync >/dev/null 2>&1; then
      mkdir -p "$dest_dir/$skill_name"
      rsync -a --delete "$SRC_DIR/$skill_name/" "$dest_dir/$skill_name/"
    else
      rm -rf "$dest_dir/$skill_name"
      cp -a "$SRC_DIR/$skill_name" "$dest_dir/$skill_name"
    fi
  done

  mv "$manifest_tmp" "$manifest_path"
  printf 'Installed repo-managed skills into %s\n' "$dest_dir"
}

for dest_dir in "${DEST_DIRS[@]}"; do
  install_to_dest "$dest_dir"
done

printf 'Restart Codex to pick up skill changes.\n'
