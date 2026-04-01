#!/usr/bin/env bash
set -euo pipefail

DEFAULT_CODEX_DIR="${CODEX_HOME:-$HOME/.codex}/skills"
DEFAULT_AGENTS_DIR="$HOME/.agents/skills"
MODE="${1:---check}"

usage() {
  cat <<'USAGE'
Usage:
  bash scripts/sync-installed-extras.sh --check
  bash scripts/sync-installed-extras.sh --sync

Compares installed skill directories between:
  ~/.codex/skills
  ~/.agents/skills

This script is for preserved or externally installed skills that are not managed
by this repo's `.codex-skills-managed` manifest. It copies only missing skill
directories and does not edit the managed manifest.
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

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

codex_list="$tmpdir/codex.txt"
agents_list="$tmpdir/agents.txt"
codex_only="$tmpdir/codex-only.txt"
agents_only="$tmpdir/agents-only.txt"

find "$DEFAULT_CODEX_DIR" -type f -name SKILL.md \
  | sed "s#^$DEFAULT_CODEX_DIR/##" \
  | sed 's#/SKILL\.md$##' \
  | sort > "$codex_list"

find "$DEFAULT_AGENTS_DIR" -type f -name SKILL.md \
  | sed "s#^$DEFAULT_AGENTS_DIR/##" \
  | sed 's#/SKILL\.md$##' \
  | sort > "$agents_list"

comm -23 "$codex_list" "$agents_list" > "$codex_only"
comm -13 "$codex_list" "$agents_list" > "$agents_only"

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

copy_missing() {
  local src_root="$1"
  local dest_root="$2"
  local file="$3"

  while IFS= read -r skill_dir; do
    [[ -z "$skill_dir" ]] && continue
    cp -a "$src_root/$skill_dir" "$dest_root/"
  done < "$file"
}

print_list "Present only in $DEFAULT_CODEX_DIR:" "$codex_only"
print_list "Present only in $DEFAULT_AGENTS_DIR:" "$agents_only"

if [[ ! -s "$codex_only" && ! -s "$agents_only" ]]; then
  echo "Installed skill trees are in sync."
  exit 0
fi

if [[ "$MODE" == "--check" ]]; then
  exit 1
fi

copy_missing "$DEFAULT_CODEX_DIR" "$DEFAULT_AGENTS_DIR" "$codex_only"
copy_missing "$DEFAULT_AGENTS_DIR" "$DEFAULT_CODEX_DIR" "$agents_only"

echo "Copied missing installed skill directories both ways."
