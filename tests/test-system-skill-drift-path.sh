#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_ROOT="$(mktemp -d)"
trap 'rm -rf "$TEST_ROOT"' EXIT

fixture="$TEST_ROOT/repo"
mkdir -p "$fixture" "$TEST_ROOT/runtime/skills/.system/builtin"
cp -R "$REPO_DIR/scripts" "$REPO_DIR/skills" "$REPO_DIR/docs" "$fixture/"
cp "$REPO_DIR/README.md" "$REPO_DIR/vendor-skills.lock" "$fixture/"
printf 'initial builtin\n' > "$TEST_ROOT/runtime/skills/.system/builtin/SKILL.md"

run_in_fixture() {
  env CODEX_HOME="$TEST_ROOT/runtime" \
    AGENTS_SKILLS_DIR="$TEST_ROOT/agents" \
    CURSOR_SKILLS_DIR="$TEST_ROOT/cursor" \
    CLAUDE_SKILLS_DIR="$TEST_ROOT/claude" \
    CODEX_SKILLS_DIR="$TEST_ROOT/legacy" \
    SYSTEM_SKILL_STRICT=1 \
    bash "$@"
}

run_in_fixture "$fixture/scripts/install.sh" >/dev/null
run_in_fixture "$fixture/scripts/system-skill-lock.sh" --write >/dev/null
run_in_fixture "$fixture/scripts/check-drift.sh" > "$TEST_ROOT/aligned.txt"
grep -q 'pinned system skills aligned' "$TEST_ROOT/aligned.txt"
grep -q 'Result: OK' "$TEST_ROOT/aligned.txt"
test ! -e "$TEST_ROOT/agents/.system"

# A changed runtime skill must still fail the enforced lock check.
printf 'changed builtin\n' > "$TEST_ROOT/runtime/skills/.system/builtin/SKILL.md"
if run_in_fixture "$fixture/scripts/check-drift.sh" > "$TEST_ROOT/drift.txt"; then
  printf 'check-drift accepted a changed Codex system skill\n' >&2
  exit 1
fi
grep -q 'system skills with hash drift' "$TEST_ROOT/drift.txt"
grep -q 'builtin expected=' "$TEST_ROOT/drift.txt"

printf 'system skill drift checks the Codex runtime root and still detects changed content\n'
