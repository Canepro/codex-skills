#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_DIR="$REPO_DIR/skills"
SYSTEM_LOCK_FILE="$REPO_DIR/system-skills.lock"

printf 'Repo-managed skills:\n'
find "$SKILLS_DIR" -mindepth 1 -maxdepth 1 -type d -printf '  - %f\n' | sort

printf '\nPinned system skills:\n'
if [[ -f "$SYSTEM_LOCK_FILE" ]]; then
  grep -vE '^[[:space:]]*(#|$)' "$SYSTEM_LOCK_FILE" | awk '{print "  - " $1}'
else
  printf '  - missing system-skills.lock\n'
fi
