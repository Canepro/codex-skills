#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOCK_FILE="${SYSTEM_SKILL_LOCK_FILE:-$REPO_DIR/system-skills.lock}"
SYSTEM_DIR="${CODEX_HOME:-$HOME/.codex}/skills/.system"
MODE="--print"

usage() {
  cat <<'USAGE'
Usage:
  bash scripts/system-skill-lock.sh --print [--dir <system-skill-dir>]
  bash scripts/system-skill-lock.sh --write [--dir <system-skill-dir>]

Prints or refreshes the pinned system-skill lock based on a Codex .system tree.
USAGE
}

dir_digest() {
  local dir="$1"

  (
    cd "$dir"
    find . -type f -print | sort | while IFS= read -r path; do
      sha256sum "$path"
    done
  ) | sha256sum | awk '{print $1}'
}

print_lock_lines() {
  if [[ ! -d "$SYSTEM_DIR" ]]; then
    printf 'Missing system skill directory: %s\n' "$SYSTEM_DIR" >&2
    exit 1
  fi

  for skill_dir in "$SYSTEM_DIR"/*; do
    [[ -d "$skill_dir" ]] || continue
    printf '%s %s\n' "$(basename "$skill_dir")" "$(dir_digest "$skill_dir")"
  done | sort
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --print|--write)
      MODE="$1"
      shift
      ;;
    --dir)
      SYSTEM_DIR="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      usage >&2
      exit 2
      ;;
  esac
done

if [[ "$MODE" == "--print" ]]; then
  print_lock_lines
  exit 0
fi

{
  echo '# Pinned Codex system skill contract for this environment.'
  echo '# Refresh intentionally with: bash scripts/system-skill-lock.sh --write'
  print_lock_lines
} > "$LOCK_FILE"

printf 'Wrote %s\n' "$LOCK_FILE"
