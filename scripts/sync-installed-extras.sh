#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="$REPO_DIR/skills"
DEFAULT_AGENTS_DIR="${AGENTS_SKILLS_DIR:-$HOME/.agents/skills}"
DEFAULT_CLAUDE_DIR="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
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
  [[ -d "$dir" ]] || return 0
  find -L "$dir" -mindepth 1 -maxdepth 1 -type d ! -name '.*' -exec basename {} \; | sort
}

usage() {
  cat <<'USAGE'
Usage:
  bash scripts/sync-installed-extras.sh --check
  bash scripts/sync-installed-extras.sh --sync

Checks non-repo skills in ~/.agents/skills, the canonical user-skill root used
by Codex, and mirrors them one way into ~/.claude/skills. Claude-only extras are
left untouched. List a name in ~/.claude/skills/.codex-skills-claude-exclude to
keep that skill out of Claude Code.
USAGE
}

if [[ "$MODE" != "--check" && "$MODE" != "--sync" ]]; then
  usage >&2
  exit 2
fi

if [[ ! -d "$DEFAULT_AGENTS_DIR" ]]; then
  echo "Canonical installed skill directory does not exist: $DEFAULT_AGENTS_DIR" >&2
  exit 1
fi

ensure_tmpdir
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

repo_list="$tmpdir/repo.txt"
agents_all="$tmpdir/agents-all.txt"
agents_external="$tmpdir/agents-external.txt"
claude_missing="$tmpdir/claude-missing.txt"
claude_drift="$tmpdir/claude-drift.txt"
claude_excluded_present="$tmpdir/claude-excluded-present.txt"
claude_exclude_file="$DEFAULT_CLAUDE_DIR/.codex-skills-claude-exclude"

list_top_level_dirs "$SRC_DIR" > "$repo_list"
list_top_level_dirs "$DEFAULT_AGENTS_DIR" > "$agents_all"
comm -13 "$repo_list" "$agents_all" > "$agents_external"
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
  if claude_is_excluded "$skill_dir"; then
    if [[ -d "$DEFAULT_CLAUDE_DIR/$skill_dir" ]]; then
      printf '%s\n' "$skill_dir" >> "$claude_excluded_present"
    fi
    continue
  fi
  if [[ ! -d "$DEFAULT_CLAUDE_DIR/$skill_dir" ]]; then
    printf '%s\n' "$skill_dir" >> "$claude_missing"
  elif dir_has_drift "$DEFAULT_AGENTS_DIR/$skill_dir" "$DEFAULT_CLAUDE_DIR/$skill_dir"; then
    printf '%s\n' "$skill_dir" >> "$claude_drift"
  fi
done < "$agents_external"

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

print_list "Agent externals missing from $DEFAULT_CLAUDE_DIR:" "$claude_missing"
print_list "Agent externals with drift in $DEFAULT_CLAUDE_DIR:" "$claude_drift"
print_list "Excluded skills still present in $DEFAULT_CLAUDE_DIR:" "$claude_excluded_present"

if [[ ! -s "$claude_missing" && ! -s "$claude_drift" && ! -s "$claude_excluded_present" ]]; then
  echo "External installed skill directories are in sync."
  exit 0
fi

if [[ "$MODE" == "--check" ]]; then
  exit 1
fi

mkdir -p "$DEFAULT_CLAUDE_DIR"
while IFS= read -r skill_dir; do
  [[ -n "$skill_dir" ]] || continue
  sync_dir "$DEFAULT_AGENTS_DIR/$skill_dir" "$DEFAULT_CLAUDE_DIR/$skill_dir"
done < <(cat "$claude_missing" "$claude_drift")

while IFS= read -r skill_dir; do
  [[ -n "$skill_dir" ]] || continue
  rm -rf "${DEFAULT_CLAUDE_DIR:?}/$skill_dir"
done < "$claude_excluded_present"

echo "Synced external installed skill directories."
