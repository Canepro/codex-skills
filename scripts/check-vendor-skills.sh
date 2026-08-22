#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOCK_FILE="$REPO_DIR/vendor-skills.lock"
VENDOR_SKILLS=(last30days)

if [[ ! -f "$LOCK_FILE" ]]; then
  printf '[vendor-skills]\n  status: missing %s\n' "$LOCK_FILE"
  exit 1
fi

expected_files_file="$(mktemp "${TMPDIR:-/tmp}/codex-vendor-skills.XXXXXX")"
trap 'rm -f "$expected_files_file"' EXIT

hash_file() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | awk '{print $1}'
  else
    shasum -a 256 "$1" | awk '{print $1}'
  fi
}

printf '[vendor-skills]\n'

while read -r expected_hash repo_path upstream_path; do
  [[ -n "${expected_hash:-}" ]] || continue
  [[ "$expected_hash" == \#* ]] && continue

  file_path="$REPO_DIR/$repo_path"
  if [[ ! -f "$file_path" ]]; then
    printf '  missing: %s (upstream %s)\n' "$repo_path" "$upstream_path"
    exit 1
  fi

  actual_hash="$(hash_file "$file_path")"
  if [[ "$actual_hash" != "$expected_hash" ]]; then
    printf '  modified: %s\n' "$repo_path"
    printf '    expected: %s\n' "$expected_hash"
    printf '    actual:   %s\n' "$actual_hash"
    exit 1
  fi

  if [[ "$repo_path" == skills/* ]]; then
    printf '%s\n' "$repo_path" >> "$expected_files_file"
  fi
done < "$LOCK_FILE"

for skill_name in "${VENDOR_SKILLS[@]}"; do
  while IFS= read -r -d '' file_path; do
    repo_path="${file_path#"$REPO_DIR/"}"
    repo_path="${repo_path//\\//}"
    if ! grep -Fqx "$repo_path" "$expected_files_file"; then
      printf '  untracked vendor file: %s\n' "$repo_path"
      exit 1
    fi
  done < <(find "$REPO_DIR/skills/$skill_name" -type f -print0)
done

printf '  status: configured portable vendor files match vendor-skills.lock\n'
