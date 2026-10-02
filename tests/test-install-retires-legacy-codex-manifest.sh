#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_ROOT="$(mktemp -d)"

cleanup() {
  rm -rf "$TEST_ROOT"
}
trap cleanup EXIT

run_with_test_roots() {
  AGENTS_SKILLS_DIR="$TEST_ROOT/agents" \
  CURSOR_SKILLS_DIR="$TEST_ROOT/cursor" \
  CLAUDE_SKILLS_DIR="$TEST_ROOT/claude" \
  CODEX_SKILLS_DIR="$TEST_ROOT/codex" \
  SYSTEM_SKILL_STRICT=0 \
    bash "$@"
}

legacy="$TEST_ROOT/codex"
mkdir -p "$legacy/retired-skill" "$TEST_ROOT/vendor/teach"
printf '%s\n' '---' 'name: retired-skill' 'description: Private copy.' '---' > "$legacy/retired-skill/SKILL.md"
ln -s "$TEST_ROOT/vendor/teach" "$legacy/teach"
printf '%s\n' resolving-merge-conflicts retired-skill teach > "$legacy/.codex-skills-managed"

if run_with_test_roots "$REPO_DIR/scripts/check-drift.sh" > "$TEST_ROOT/before.txt"; then
  printf 'drift check passed with a retired Codex manifest present\n' >&2
  exit 1
fi
grep -q 'retired manifest present' "$TEST_ROOT/before.txt"

run_with_test_roots "$REPO_DIR/scripts/install.sh" >/dev/null

if [[ -e "$legacy/.codex-skills-managed" ]]; then
  printf 'legacy Codex manifest was not retired\n' >&2
  exit 1
fi
if [[ ! -f "$legacy/retired-skill/SKILL.md" || ! -L "$legacy/teach" ]]; then
  printf 'retiring the manifest removed a skill it listed\n' >&2
  exit 1
fi

run_with_test_roots "$REPO_DIR/scripts/check-drift.sh" > "$TEST_ROOT/after.txt"
grep -q 'no legacy manifest' "$TEST_ROOT/after.txt"

printf 'install retired the legacy Codex manifest and kept the skills it listed\n'
