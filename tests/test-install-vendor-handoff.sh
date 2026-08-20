#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_ROOT="$(mktemp -d)"

cleanup() {
  rm -rf "$TEST_ROOT"
}
trap cleanup EXIT

vendor_skill="$TEST_ROOT/vendor/domain-modeling"
mkdir -p "$vendor_skill"
printf '%s\n' '---' 'name: domain-modeling' 'description: Test vendor skill.' '---' > "$vendor_skill/SKILL.md"

for runtime in agents cursor claude; do
  runtime_dir="$TEST_ROOT/$runtime"
  mkdir -p "$runtime_dir"
  ln -s "$vendor_skill" "$runtime_dir/domain-modeling"
  printf '%s\n' domain-modeling > "$runtime_dir/.codex-skills-managed"
done

AGENTS_SKILLS_DIR="$TEST_ROOT/agents" \
CURSOR_SKILLS_DIR="$TEST_ROOT/cursor" \
CLAUDE_SKILLS_DIR="$TEST_ROOT/claude" \
  bash "$REPO_DIR/scripts/install.sh" >/dev/null

for runtime in agents cursor claude; do
  runtime_dir="$TEST_ROOT/$runtime"
  if [[ ! -L "$runtime_dir/domain-modeling" ]]; then
    printf 'vendor symlink was removed from %s\n' "$runtime" >&2
    exit 1
  fi
  if grep -qx domain-modeling "$runtime_dir/.codex-skills-managed"; then
    printf 'stale portable manifest entry remains in %s\n' "$runtime" >&2
    exit 1
  fi
done

printf 'vendor handoff preserved external symlinks and pruned stale manifest entries\n'
