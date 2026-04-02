#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_DIR="$REPO_DIR/skills"
SYSTEM_LOCK_FILE="$REPO_DIR/system-skills.lock"

list_top_level_dirs() {
  local dir="$1"

  if [[ ! -d "$dir" ]]; then
    return 0
  fi

  for path in "$dir"/*; do
    [[ -d "$path" ]] || continue
    basename "$path"
  done | sort
}

printf 'Repo-managed skills:\n'
list_top_level_dirs "$SKILLS_DIR" | sed 's/^/  - /'

printf '\nPinned system skills:\n'
if [[ -f "$SYSTEM_LOCK_FILE" ]]; then
  grep -vE '^[[:space:]]*(#|$)' "$SYSTEM_LOCK_FILE" | awk '{print "  - " $1}'
else
  printf '  - missing system-skills.lock\n'
fi
