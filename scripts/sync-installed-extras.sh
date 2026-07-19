#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="$REPO_DIR/skills"
DEFAULT_CODEX_DIR="${CODEX_HOME:-$HOME/.codex}/skills"
DEFAULT_AGENTS_DIR="$HOME/.agents/skills"
DEFAULT_CLAUDE_DIR="$HOME/.claude/skills"
MODE="${1:---check}"

ensure_tmpdir() {
  if [[ -n "${TMPDIR:-}" && -d "${TMPDIR:-}" ]]; then
    return 0
  fi

  if [[ -n "${TMP:-}" && -d "$TMP" ]]; then
    export TMPDIR="$TMP"
  elif [[ -n "${TEMP:-}" && -d "$TEMP" ]]; then
    export TMPDIR="$TEMP"
  else
    export TMPDIR="$REPO_DIR/.tmp"
    mkdir -p "$TMPDIR"
  fi
}

list_top_level_dirs() {
  local dir="$1"

  if [[ ! -d "$dir" ]]; then
    return 0
  fi

  find -L "$dir" -mindepth 1 -maxdepth 1 -type d ! -name '.*' -exec basename {} \; | sort
}

usage() {
  cat <<'USAGE'
Usage:
  bash scripts/sync-installed-extras.sh --check
  bash scripts/sync-installed-extras.sh --sync

Compares non-repo skill directories between:
  ~/.codex/skills
  ~/.agents/skills

This script is for installed entries that are not managed by this repo's skills/
directory. Shared entries with content drift are synced from ~/.codex/skills into
~/.agents/skills, because the Codex tree is the usual source for private local
extras. Hidden system directories such as .system are handled by
system-skills.lock and check-drift.sh, not by this mirror script.

The Codex and Agents roots may be separate mirrors or symlink aliases to the
same canonical tree. Symlinked roots and top-level skill directories are
traversed and compared normally.

Codex-tree externals are also mirrored one way into ~/.claude/skills so private
skills stay discoverable by Claude Code. Claude-only externals are left
untouched. To keep a private skill out of Claude Code, list its name in
~/.claude/skills/.codex-skills-claude-exclude (one name per line); --sync skips
excluded skills and removes them from the claude tree if present.
USAGE
}

if [[ "$MODE" != "--check" && "$MODE" != "--sync" ]]; then
  usage >&2
  exit 2
fi

if [[ ! -d "$DEFAULT_CODEX_DIR" || ! -d "$DEFAULT_AGENTS_DIR" ]]; then
  echo "Installed skill directories must already exist." >&2
  exit 1
fi

ensure_tmpdir
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

repo_list="$tmpdir/repo.txt"
codex_all="$tmpdir/codex-all.txt"
agents_all="$tmpdir/agents-all.txt"
codex_external="$tmpdir/codex-external.txt"
agents_external="$tmpdir/agents-external.txt"
codex_only="$tmpdir/codex-only.txt"
agents_only="$tmpdir/agents-only.txt"
shared_external="$tmpdir/shared-external.txt"
shared_drift="$tmpdir/shared-drift.txt"

list_top_level_dirs "$SRC_DIR" > "$repo_list"
list_top_level_dirs "$DEFAULT_CODEX_DIR" > "$codex_all"
list_top_level_dirs "$DEFAULT_AGENTS_DIR" > "$agents_all"

comm -13 "$repo_list" "$codex_all" > "$codex_external"
comm -13 "$repo_list" "$agents_all" > "$agents_external"
comm -23 "$codex_external" "$agents_external" > "$codex_only"
comm -13 "$codex_external" "$agents_external" > "$agents_only"
comm -12 "$codex_external" "$agents_external" > "$shared_external"

claude_missing="$tmpdir/claude-missing.txt"
claude_drift="$tmpdir/claude-drift.txt"
claude_excluded_present="$tmpdir/claude-excluded-present.txt"
claude_exclude_file="$DEFAULT_CLAUDE_DIR/.codex-skills-claude-exclude"
: > "$shared_drift"
: > "$claude_missing"
: > "$claude_drift"
: > "$claude_excluded_present"

claude_is_excluded() {
  [[ -f "$claude_exclude_file" ]] && grep -qxF "$1" "$claude_exclude_file"
}

dir_has_drift() {
  local src_dir="$1"
  local dest_dir="$2"

  if command -v rsync >/dev/null 2>&1; then
    rsync -ain --delete "$src_dir/" "$dest_dir/" | grep -q .
    return
  fi

  ! diff -qr "$src_dir" "$dest_dir" >/dev/null 2>&1
}

sync_dir() {
  local src_dir="$1"
  local dest_dir="$2"

  mkdir -p "$dest_dir"

  if command -v rsync >/dev/null 2>&1; then
    rsync -a --delete "$src_dir/" "$dest_dir/"
  else
    rm -rf "$dest_dir"
    cp -a "$src_dir" "$dest_dir"
  fi
}

while IFS= read -r skill_dir; do
  [[ -n "$skill_dir" ]] || continue
  if dir_has_drift "$DEFAULT_CODEX_DIR/$skill_dir" "$DEFAULT_AGENTS_DIR/$skill_dir"; then
    printf '%s\n' "$skill_dir" >> "$shared_drift"
  fi
done < "$shared_external"

while IFS= read -r skill_dir; do
  [[ -n "$skill_dir" ]] || continue
  if claude_is_excluded "$skill_dir"; then
    if [[ -d "$DEFAULT_CLAUDE_DIR/$skill_dir" ]]; then
      printf '%s\n' "$skill_dir" >> "$claude_excluded_present"
    fi
    continue
  fi
  if [[ ! -d "$DEFAULT_CLAUDE_DIR/$skill_dir" ]]; then
    printf '%s\n' "$skill_dir" >> "$claude_missing"
  elif dir_has_drift "$DEFAULT_CODEX_DIR/$skill_dir" "$DEFAULT_CLAUDE_DIR/$skill_dir"; then
    printf '%s\n' "$skill_dir" >> "$claude_drift"
  fi
done < "$codex_external"

print_list() {
  local title="$1"
  local file="$2"

  echo "$title"
  if [[ -s "$file" ]]; then
    sed 's/^/  - /' "$file"
  else
    echo "  - none"
  fi
}

print_list "External only in $DEFAULT_CODEX_DIR:" "$codex_only"
print_list "External only in $DEFAULT_AGENTS_DIR:" "$agents_only"
print_list "Shared external entries with content drift:" "$shared_drift"
print_list "Codex externals missing from $DEFAULT_CLAUDE_DIR:" "$claude_missing"
print_list "Codex externals with drift in $DEFAULT_CLAUDE_DIR:" "$claude_drift"
print_list "Excluded skills still present in $DEFAULT_CLAUDE_DIR:" "$claude_excluded_present"

if [[ ! -s "$codex_only" && ! -s "$agents_only" && ! -s "$shared_drift" && ! -s "$claude_missing" && ! -s "$claude_drift" && ! -s "$claude_excluded_present" ]]; then
  echo "External installed skill directories are in sync."
  exit 0
fi

if [[ "$MODE" == "--check" ]]; then
  exit 1
fi

while IFS= read -r skill_dir; do
  [[ -n "$skill_dir" ]] || continue
  sync_dir "$DEFAULT_CODEX_DIR/$skill_dir" "$DEFAULT_AGENTS_DIR/$skill_dir"
done < "$codex_only"

while IFS= read -r skill_dir; do
  [[ -n "$skill_dir" ]] || continue
  sync_dir "$DEFAULT_AGENTS_DIR/$skill_dir" "$DEFAULT_CODEX_DIR/$skill_dir"
done < "$agents_only"

while IFS= read -r skill_dir; do
  [[ -n "$skill_dir" ]] || continue
  sync_dir "$DEFAULT_CODEX_DIR/$skill_dir" "$DEFAULT_AGENTS_DIR/$skill_dir"
done < "$shared_drift"

mkdir -p "$DEFAULT_CLAUDE_DIR"
while IFS= read -r skill_dir; do
  [[ -n "$skill_dir" ]] || continue
  sync_dir "$DEFAULT_CODEX_DIR/$skill_dir" "$DEFAULT_CLAUDE_DIR/$skill_dir"
done < <(cat "$claude_missing" "$claude_drift")

while IFS= read -r skill_dir; do
  [[ -n "$skill_dir" ]] || continue
  rm -rf "${DEFAULT_CLAUDE_DIR:?}/$skill_dir"
done < "$claude_excluded_present"

echo "Synced external installed skill directories."
