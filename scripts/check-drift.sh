#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="$REPO_DIR/skills"
DEFAULT_CODEX_DIR="${CODEX_HOME:-$HOME/.codex}/skills"
DEFAULT_AGENTS_DIR="$HOME/.agents/skills"
DEFAULT_CLAUDE_DIR="$HOME/.claude/skills"
DEFAULT_CURSOR_DIR="$HOME/.cursor/skills"
MANIFEST_NAME=".codex-skills-managed"
SYSTEM_LOCK_FILE="$REPO_DIR/system-skills.lock"
HAS_ISSUES=0

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

make_tmp() {
  ensure_tmpdir
  mktemp
}

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

list_repo_skills() {
  list_top_level_dirs "$SRC_DIR"
}

list_installed_skills() {
  local dest_dir="$1"
  list_top_level_dirs "$dest_dir"
}

list_manifest_skills() {
  local manifest_path="$1"

  if [[ ! -f "$manifest_path" ]]; then
    return 0
  fi

  sort < "$manifest_path"
}

skill_has_content_drift() {
  local skill_name="$1"
  local dest_dir="$2"

  if [[ ! -d "$dest_dir/$skill_name" ]]; then
    return 1
  fi

  if command -v rsync >/dev/null 2>&1; then
    if rsync -ain --delete "$SRC_DIR/$skill_name/" "$dest_dir/$skill_name/" | grep -q .; then
      return 0
    fi
    return 1
  fi

  if diff -qr "$SRC_DIR/$skill_name" "$dest_dir/$skill_name" >/dev/null 2>&1; then
    return 1
  fi
  return 0
}

print_list() {
  local label="$1"
  local file="$2"

  if [[ -s "$file" ]]; then
    printf '  %s\n' "$label"
    sed 's/^/    - /' "$file"
  fi
}

check_destination() {
  local name="$1"
  local dest_dir="$2"
  local manifest_path="$dest_dir/$MANIFEST_NAME"
  local repo_skills_file manifest_skills_file installed_skills_file
  local repo_missing_from_manifest manifest_missing_from_repo
  local repo_missing_from_install manifest_missing_from_install external_skills
  local content_drift

  repo_skills_file="$(make_tmp)"
  manifest_skills_file="$(make_tmp)"
  installed_skills_file="$(make_tmp)"
  repo_missing_from_manifest="$(make_tmp)"
  manifest_missing_from_repo="$(make_tmp)"
  repo_missing_from_install="$(make_tmp)"
  manifest_missing_from_install="$(make_tmp)"
  external_skills="$(make_tmp)"
  content_drift="$(make_tmp)"

  trap 'rm -f "$repo_skills_file" "$manifest_skills_file" "$installed_skills_file" "$repo_missing_from_manifest" "$manifest_missing_from_repo" "$repo_missing_from_install" "$manifest_missing_from_install" "$external_skills" "$content_drift"' RETURN

  list_repo_skills > "$repo_skills_file"
  list_manifest_skills "$manifest_path" > "$manifest_skills_file"
  list_installed_skills "$dest_dir" > "$installed_skills_file"

  printf '\n[%s]\n' "$name"
  printf '  path: %s\n' "$dest_dir"

  if [[ ! -d "$dest_dir" ]]; then
    printf '  status: missing destination directory\n'
    HAS_ISSUES=1
    return 0
  fi

  if [[ ! -f "$manifest_path" ]]; then
    printf '  status: missing manifest %s\n' "$manifest_path"
    HAS_ISSUES=1
    return 0
  fi

  comm -23 "$repo_skills_file" "$manifest_skills_file" > "$repo_missing_from_manifest"
  comm -13 "$repo_skills_file" "$manifest_skills_file" > "$manifest_missing_from_repo"
  comm -23 "$repo_skills_file" "$installed_skills_file" > "$repo_missing_from_install"
  comm -23 "$manifest_skills_file" "$installed_skills_file" > "$manifest_missing_from_install"
  comm -13 "$repo_skills_file" "$installed_skills_file" > "$external_skills"

  while IFS= read -r skill_name; do
    [[ -n "$skill_name" ]] || continue
    if skill_has_content_drift "$skill_name" "$dest_dir"; then
      printf '%s\n' "$skill_name" >> "$content_drift"
    fi
  done < "$repo_skills_file"

  if [[ -s "$repo_missing_from_manifest" || -s "$manifest_missing_from_repo" || -s "$repo_missing_from_install" || -s "$manifest_missing_from_install" || -s "$content_drift" ]]; then
    printf '  status: drift detected\n'
    HAS_ISSUES=1
  else
    printf '  status: repo-managed skills aligned\n'
  fi

  print_list 'repo skills missing from manifest:' "$repo_missing_from_manifest"
  print_list 'manifest entries missing from repo:' "$manifest_missing_from_repo"
  print_list 'repo skills missing from install:' "$repo_missing_from_install"
  print_list 'manifest entries missing from install:' "$manifest_missing_from_install"
  print_list 'installed skills with content drift:' "$content_drift"
  print_list 'external or preserved installed skills:' "$external_skills"
}

list_claude_installed_skills() {
  local dir="$1"

  if [[ ! -d "$dir" ]]; then
    return 0
  fi

  find "$dir" -mindepth 1 -maxdepth 1 -type f -name '*.md' -exec basename {} .md \; | sort
}

claude_skill_has_content_drift() {
  local skill_name="$1"
  local dest_dir="$2"

  if [[ ! -f "$dest_dir/$skill_name.md" ]]; then
    return 1
  fi

  ! diff -q "$SRC_DIR/$skill_name/SKILL.md" "$dest_dir/$skill_name.md" >/dev/null 2>&1
}

check_claude_destination() {
  local name="$1"
  local dest_dir="$2"
  local manifest_path="$dest_dir/$MANIFEST_NAME"
  local repo_skills_file manifest_skills_file installed_skills_file
  local repo_missing_from_manifest manifest_missing_from_repo
  local repo_missing_from_install manifest_missing_from_install external_skills
  local content_drift

  repo_skills_file="$(make_tmp)"
  manifest_skills_file="$(make_tmp)"
  installed_skills_file="$(make_tmp)"
  repo_missing_from_manifest="$(make_tmp)"
  manifest_missing_from_repo="$(make_tmp)"
  repo_missing_from_install="$(make_tmp)"
  manifest_missing_from_install="$(make_tmp)"
  external_skills="$(make_tmp)"
  content_drift="$(make_tmp)"

  trap 'rm -f "$repo_skills_file" "$manifest_skills_file" "$installed_skills_file" "$repo_missing_from_manifest" "$manifest_missing_from_repo" "$repo_missing_from_install" "$manifest_missing_from_install" "$external_skills" "$content_drift"' RETURN

  list_repo_skills > "$repo_skills_file"
  list_manifest_skills "$manifest_path" > "$manifest_skills_file"
  list_claude_installed_skills "$dest_dir" > "$installed_skills_file"

  printf '\n[%s]\n' "$name"
  printf '  path: %s\n' "$dest_dir"

  if [[ ! -d "$dest_dir" ]]; then
    printf '  status: missing destination directory\n'
    HAS_ISSUES=1
    return 0
  fi

  if [[ ! -f "$manifest_path" ]]; then
    printf '  status: missing manifest %s\n' "$manifest_path"
    HAS_ISSUES=1
    return 0
  fi

  comm -23 "$repo_skills_file" "$manifest_skills_file" > "$repo_missing_from_manifest"
  comm -13 "$repo_skills_file" "$manifest_skills_file" > "$manifest_missing_from_repo"
  comm -23 "$repo_skills_file" "$installed_skills_file" > "$repo_missing_from_install"
  comm -23 "$manifest_skills_file" "$installed_skills_file" > "$manifest_missing_from_install"
  comm -13 "$repo_skills_file" "$installed_skills_file" > "$external_skills"

  while IFS= read -r skill_name; do
    [[ -n "$skill_name" ]] || continue
    if claude_skill_has_content_drift "$skill_name" "$dest_dir"; then
      printf '%s\n' "$skill_name" >> "$content_drift"
    fi
  done < "$repo_skills_file"

  if [[ -s "$repo_missing_from_manifest" || -s "$manifest_missing_from_repo" || -s "$repo_missing_from_install" || -s "$manifest_missing_from_install" || -s "$content_drift" ]]; then
    printf '  status: drift detected\n'
    HAS_ISSUES=1
  else
    printf '  status: repo-managed skills aligned\n'
  fi

  print_list 'repo skills missing from manifest:' "$repo_missing_from_manifest"
  print_list 'manifest entries missing from repo:' "$manifest_missing_from_repo"
  print_list 'repo skills missing from install:' "$repo_missing_from_install"
  print_list 'manifest entries missing from install:' "$manifest_missing_from_install"
  print_list 'installed skills with content drift:' "$content_drift"
  print_list 'external or preserved installed skills:' "$external_skills"
}

check_system_skills() {
  local name="$1"
  local system_dir="$2"
  local expected_full expected_names current_full current_names missing unexpected hash_drift shared_names

  expected_full="$(make_tmp)"
  expected_names="$(make_tmp)"
  current_full="$(make_tmp)"
  current_names="$(make_tmp)"
  missing="$(make_tmp)"
  unexpected="$(make_tmp)"
  hash_drift="$(make_tmp)"
  shared_names="$(make_tmp)"

  trap 'rm -f "$expected_full" "$expected_names" "$current_full" "$current_names" "$missing" "$unexpected" "$hash_drift" "$shared_names"' RETURN

  printf '\n[%s-system]\n' "$name"
  printf '  path: %s\n' "$system_dir"

  if [[ ! -f "$SYSTEM_LOCK_FILE" ]]; then
    printf '  status: missing system skill lock %s\n' "$SYSTEM_LOCK_FILE"
    HAS_ISSUES=1
    return 0
  fi

  if [[ ! -d "$system_dir" ]]; then
    # Codex 0.139+ no longer materializes ~/.codex/skills/.system. An absent
    # directory means the agent does not provide system skills here; only a
    # present-but-drifted directory counts as drift.
    printf '  status: no system skill directory (agent does not provide one; not counted as drift)\n'
    return 0
  fi

  grep -vE '^[[:space:]]*(#|$)' "$SYSTEM_LOCK_FILE" | sort > "$expected_full"
  awk '{print $1}' "$expected_full" > "$expected_names"
  bash "$REPO_DIR/scripts/system-skill-lock.sh" --print --dir "$system_dir" | sort > "$current_full"
  awk '{print $1}' "$current_full" > "$current_names"

  comm -23 "$expected_names" "$current_names" > "$missing"
  comm -13 "$expected_names" "$current_names" > "$unexpected"
  comm -12 "$expected_names" "$current_names" > "$shared_names"

  while IFS= read -r skill_name; do
    [[ -n "$skill_name" ]] || continue
    expected_hash="$(awk -v name="$skill_name" '$1 == name { print $2 }' "$expected_full")"
    current_hash="$(awk -v name="$skill_name" '$1 == name { print $2 }' "$current_full")"
    if [[ "$expected_hash" != "$current_hash" ]]; then
      printf '%s expected=%s current=%s\n' "$skill_name" "$expected_hash" "$current_hash" >> "$hash_drift"
    fi
  done < "$shared_names"

  if [[ -s "$missing" || -s "$unexpected" || -s "$hash_drift" ]]; then
    printf '  status: drift detected\n'
    HAS_ISSUES=1
  else
    printf '  status: pinned system skills aligned\n'
  fi

  print_list 'locked system skills missing from install:' "$missing"
  print_list 'unexpected installed system skills:' "$unexpected"
  print_list 'system skills with hash drift:' "$hash_drift"
}

check_installed_tree_alignment() {
  local codex_skills agents_skills codex_only agents_only

  codex_skills="$(make_tmp)"
  agents_skills="$(make_tmp)"
  codex_only="$(make_tmp)"
  agents_only="$(make_tmp)"

  trap 'rm -f "$codex_skills" "$agents_skills" "$codex_only" "$agents_only"' RETURN

  list_installed_skills "$DEFAULT_CODEX_DIR" > "$codex_skills"
  list_installed_skills "$DEFAULT_AGENTS_DIR" > "$agents_skills"

  comm -23 "$codex_skills" "$agents_skills" > "$codex_only"
  comm -13 "$codex_skills" "$agents_skills" > "$agents_only"

  printf '\n[installed-tree-alignment]\n'

  if [[ -s "$codex_only" || -s "$agents_only" ]]; then
    printf '  status: drift detected between installed skill trees\n'
    HAS_ISSUES=1
  else
    printf '  status: installed skill trees aligned\n'
  fi

  print_list 'installed only in codex:' "$codex_only"
  print_list 'installed only in agents:' "$agents_only"
}

check_docs_sync() {
  local readme="$REPO_DIR/README.md"
  local doc="$REPO_DIR/docs/how-to-manage-skills.md"
  local repo_skills_file readme_names doc_names
  local repo_missing_from_readme readme_missing_from_repo
  local repo_missing_from_doc doc_missing_from_repo

  repo_skills_file="$(make_tmp)"
  readme_names="$(make_tmp)"
  doc_names="$(make_tmp)"
  repo_missing_from_readme="$(make_tmp)"
  readme_missing_from_repo="$(make_tmp)"
  repo_missing_from_doc="$(make_tmp)"
  doc_missing_from_repo="$(make_tmp)"

  trap 'rm -f "$repo_skills_file" "$readme_names" "$doc_names" "$repo_missing_from_readme" "$readme_missing_from_repo" "$repo_missing_from_doc" "$doc_missing_from_repo"' RETURN

  printf '\n[docs-sync]\n'

  if [[ ! -f "$readme" || ! -f "$doc" ]]; then
    printf '  status: missing README.md or docs/how-to-manage-skills.md\n'
    HAS_ISSUES=1
    return 0
  fi

  list_repo_skills > "$repo_skills_file"

  awk '/^## What Is Included$/{flag=1; next} /^## /{flag=0} flag' "$readme" \
    | { grep -oE '`[a-z0-9-]+`' || true; } | tr -d '`' | sort -u > "$readme_names"

  awk '/^## Current available skills$/{flag=1; next} /^## /{flag=0} /^Pinned system skills/{flag=0} flag' "$doc" \
    | { grep -E '^- `[a-z0-9-]+`$' || true; } | tr -d '`' | sed 's/^- //' | sort -u > "$doc_names"

  comm -23 "$repo_skills_file" "$readme_names" > "$repo_missing_from_readme"
  comm -13 "$repo_skills_file" "$readme_names" > "$readme_missing_from_repo"
  comm -23 "$repo_skills_file" "$doc_names" > "$repo_missing_from_doc"
  comm -13 "$repo_skills_file" "$doc_names" > "$doc_missing_from_repo"

  if [[ -s "$repo_missing_from_readme" || -s "$readme_missing_from_repo" || -s "$repo_missing_from_doc" || -s "$doc_missing_from_repo" ]]; then
    printf '  status: docs out of sync with skills/\n'
    HAS_ISSUES=1
  else
    printf '  status: README and docs skill lists aligned\n'
  fi

  print_list 'repo skills missing from README "What Is Included":' "$repo_missing_from_readme"
  print_list 'README names with no skills/ directory:' "$readme_missing_from_repo"
  print_list 'repo skills missing from docs skill list:' "$repo_missing_from_doc"
  print_list 'docs list names with no skills/ directory:' "$doc_missing_from_repo"
}

printf 'Checking codex-skills drift\n'
printf '  repo: %s\n' "$REPO_DIR"
printf '  source: %s\n' "$SRC_DIR"

check_destination 'codex' "$DEFAULT_CODEX_DIR"
check_destination 'agents' "$DEFAULT_AGENTS_DIR"
check_destination 'cursor' "$DEFAULT_CURSOR_DIR"
check_claude_destination 'claude' "$DEFAULT_CLAUDE_DIR"
check_system_skills 'codex' "$DEFAULT_CODEX_DIR/.system"
check_system_skills 'agents' "$DEFAULT_AGENTS_DIR/.system"
check_installed_tree_alignment
check_docs_sync

if [[ "$HAS_ISSUES" -eq 0 ]]; then
  printf '\nResult: OK\n'
else
  printf '\nResult: DRIFT DETECTED\n'
  exit 1
fi
