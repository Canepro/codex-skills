#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="$REPO_DIR/skills"
DEFAULT_CODEX_DIR="${CODEX_HOME:-$HOME/.codex}/skills"
DEFAULT_AGENTS_DIR="$HOME/.agents/skills"
MANIFEST_NAME=".codex-skills-managed"

HAS_ISSUES=0

make_tmp() {
  mktemp
}

list_repo_skills() {
  find "$SRC_DIR" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort -u
}

list_installed_skills() {
  local dest_dir="$1"

  if [ ! -d "$dest_dir" ]; then
    return 0
  fi

  find "$dest_dir" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort -u
}

list_manifest_skills() {
  local manifest_path="$1"

  if [ ! -f "$manifest_path" ]; then
    return 0
  fi

  sort -u "$manifest_path"
}

skill_has_content_drift() {
  local skill_name="$1"
  local dest_dir="$2"

  if [ ! -d "$dest_dir/$skill_name" ]; then
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

  if [ -s "$file" ]; then
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

  if [ ! -d "$dest_dir" ]; then
    printf '  status: missing destination directory\n'
    HAS_ISSUES=1
    return 0
  fi

  if [ ! -f "$manifest_path" ]; then
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
    [ -n "$skill_name" ] || continue
    if skill_has_content_drift "$skill_name" "$dest_dir"; then
      printf '%s\n' "$skill_name" >> "$content_drift"
    fi
  done < "$repo_skills_file"

  if [ -s "$repo_missing_from_manifest" ] || [ -s "$manifest_missing_from_repo" ] || [ -s "$repo_missing_from_install" ] || [ -s "$manifest_missing_from_install" ] || [ -s "$content_drift" ]; then
    printf '  status: drift detected\n'
    HAS_ISSUES=1
  else
    printf '  status: repo-managed skills aligned\n'
  fi

  print_list "repo skills missing from manifest:" "$repo_missing_from_manifest"
  print_list "manifest entries missing from repo:" "$manifest_missing_from_repo"
  print_list "repo skills missing from install:" "$repo_missing_from_install"
  print_list "manifest entries missing from install:" "$manifest_missing_from_install"
  print_list "installed skills with content drift:" "$content_drift"
  print_list "external or preserved installed skills:" "$external_skills"
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

  if [ -s "$codex_only" ] || [ -s "$agents_only" ]; then
    printf '  status: drift detected between installed skill trees\n'
    HAS_ISSUES=1
  else
    printf '  status: installed skill trees aligned\n'
  fi

  print_list "installed only in codex:" "$codex_only"
  print_list "installed only in agents:" "$agents_only"
}

printf 'Checking codex-skills drift\n'
printf '  repo: %s\n' "$REPO_DIR"
printf '  source: %s\n' "$SRC_DIR"

check_destination "codex" "$DEFAULT_CODEX_DIR"
check_destination "agents" "$DEFAULT_AGENTS_DIR"
check_installed_tree_alignment

if [ "$HAS_ISSUES" -eq 0 ]; then
  printf '\nResult: OK\n'
else
  printf '\nResult: DRIFT DETECTED\n'
  exit 1
fi
