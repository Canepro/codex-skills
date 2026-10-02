#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="$REPO_DIR/skills"
DEFAULT_AGENTS_DIR="${AGENTS_SKILLS_DIR:-$HOME/.agents/skills}"
DEFAULT_CLAUDE_DIR="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
DEFAULT_CURSOR_DIR="${CURSOR_SKILLS_DIR:-$HOME/.cursor/skills}"
# Codex reads ~/.agents/skills. The old ~/.codex/skills install target is retired.
LEGACY_CODEX_DIR="${CODEX_SKILLS_DIR:-${CODEX_HOME:-$HOME/.codex}/skills}"

declare -a DEST_DIRS=("$DEFAULT_AGENTS_DIR" "$DEFAULT_CURSOR_DIR")

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
  local manifest_tmp manifest_sorted_tmp
  manifest_tmp="$(mktemp)"
  manifest_sorted_tmp="$(mktemp)"

  mkdir -p "$dest_dir"

  # The manifest lists repo-managed skills only. A manifest entry that left the
  # repo was deliberately deleted, so uninstall it. Private skills are never in
  # the manifest; they live as unmanaged directories and are not touched here.
  if [ -f "$manifest_path" ]; then
    while IFS= read -r old_skill; do
      [ -n "$old_skill" ] || continue
      [ -f "$SRC_DIR/$old_skill/SKILL.md" ] && continue
      # A vendor projector may have replaced a formerly repo-managed skill
      # with a link to its canonical checkout. Drop the stale manifest entry
      # without deleting the externally owned projection.
      [ -L "$dest_dir/$old_skill" ] && continue
      rm -rf "$dest_dir/$old_skill"
    done < "$manifest_path"
  fi

  for skill_path in "$SRC_DIR"/*; do
    [ -f "$skill_path/SKILL.md" ] || continue
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

  sort -u "$manifest_tmp" > "$manifest_sorted_tmp"
  mv "$manifest_sorted_tmp" "$manifest_path"
  rm -f "$manifest_tmp"
  printf 'Installed repo-managed skills into %s\n' "$dest_dir"
}

for dest_dir in "${DEST_DIRS[@]}"; do
  install_to_dest "$dest_dir"
done

install_to_claude() {
  local dest_dir="$1"
  local manifest_path="$dest_dir/.codex-skills-managed"

  mkdir -p "$dest_dir"

  # Claude Code discovers skills as <skill>/SKILL.md directories, not flat
  # <skill>.md files. Remove legacy flat-file installs from the old format,
  # then install full skill directories like every other tree.
  if [ -f "$manifest_path" ]; then
    while IFS= read -r old_skill; do
      [ -n "$old_skill" ] || continue
      rm -f "$dest_dir/$old_skill.md"
    done < "$manifest_path"
  fi

  install_to_dest "$dest_dir"
}

install_to_claude "$DEFAULT_CLAUDE_DIR"

# Before July 2026 install.sh also wrote $LEGACY_CODEX_DIR. That manifest now
# lists names this repo no longer installs there, so a reader would mistake it
# for current bookkeeping. Retire the manifest only; the directories it names
# may be vendor projections or private skills and stay in place.
retire_legacy_codex_manifest() {
  local manifest_path="$LEGACY_CODEX_DIR/.codex-skills-managed"
  if [ -f "$manifest_path" ] && [ ! -L "$manifest_path" ]; then
    rm -f "$manifest_path"
    printf 'Retired legacy manifest %s\n' "$manifest_path"
  fi
}

retire_legacy_codex_manifest

printf 'Restart Codex, Claude Code, or Cursor to pick up skill changes.\n'
