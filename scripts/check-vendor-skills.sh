#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOCK_FILE="$REPO_DIR/vendor-skills.lock"
VENDOR_SKILLS=(domain-modeling grill-with-docs grilling)

if [[ ! -f "$LOCK_FILE" ]]; then
  printf '[vendor-skills]\n  status: missing %s\n' "$LOCK_FILE"
  exit 1
fi

declare -A expected_files=()

printf '[vendor-skills]\n'

while read -r expected_hash repo_path upstream_path; do
  [[ -n "${expected_hash:-}" ]] || continue
  [[ "$expected_hash" == \#* ]] && continue

  file_path="$REPO_DIR/$repo_path"
  if [[ ! -f "$file_path" ]]; then
    printf '  missing: %s (upstream %s)\n' "$repo_path" "$upstream_path"
    exit 1
  fi

  actual_hash="$(sha256sum "$file_path" | awk '{print $1}')"
  if [[ "$actual_hash" != "$expected_hash" ]]; then
    printf '  modified: %s\n' "$repo_path"
    printf '    expected: %s\n' "$expected_hash"
    printf '    actual:   %s\n' "$actual_hash"
    exit 1
  fi

  if [[ "$repo_path" == skills/* ]]; then
    expected_files["$repo_path"]=1
  fi
done < "$LOCK_FILE"

shopt -s globstar nullglob
for skill_name in "${VENDOR_SKILLS[@]}"; do
  for file_path in "$REPO_DIR/skills/$skill_name"/**/*; do
    [[ -f "$file_path" ]] || continue
    repo_path="${file_path#"$REPO_DIR/"}"
    repo_path="${repo_path//\\//}"
    if [[ -z "${expected_files[$repo_path]+present}" ]]; then
      printf '  untracked vendor file: %s\n' "$repo_path"
      exit 1
    fi
  done
done

printf '  status: upstream files and package contents match vendor-skills.lock\n'
