#!/usr/bin/env bash
# Checks the playwright skill wrapper's launch contract without a browser: it
# runs an exact pinned @playwright/cli version and defaults to Playwright's
# Chromium build unless the caller already chose a browser or a config file.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WRAPPER="$REPO_DIR/skills/playwright/scripts/playwright_cli.sh"
TEST_ROOT="$(mktemp -d)"

cleanup() {
  rm -rf "$TEST_ROOT"
}
trap cleanup EXIT

# A recording npx stands in for the network and the browser.
mkdir -p "$TEST_ROOT/bin"
cat > "$TEST_ROOT/bin/npx" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$@" > "$RECORD_DIR/args"
printf '%s\n' "${PLAYWRIGHT_MCP_BROWSER-<unset>}" > "$RECORD_DIR/browser"
EOF
chmod +x "$TEST_ROOT/bin/npx"

failures=0

# run_case <name> <expected browser> <expected package regex> <setup> [wrapper args...]
run_case() {
  local name="$1" want_browser="$2" want_package="$3" setup="$4"
  shift 4
  local case_dir="$TEST_ROOT/$name"
  mkdir -p "$case_dir/home" "$case_dir/work" "$case_dir/record"
  (
    cd "$case_dir/work"
    export HOME="$case_dir/home" RECORD_DIR="$case_dir/record"
    export PATH="$TEST_ROOT/bin:$PATH"
    unset PLAYWRIGHT_MCP_BROWSER PLAYWRIGHT_MCP_CONFIG PLAYWRIGHT_CLI_VERSION PLAYWRIGHT_CLI_SESSION
    eval "$setup"
    bash "$WRAPPER" "$@"
  )
  local got_browser got_package
  got_browser="$(cat "$case_dir/record/browser")"
  got_package="$(sed -n '/^--package$/{n;p;q;}' "$case_dir/record/args")"
  if [[ "$got_browser" != "$want_browser" ]]; then
    printf 'FAIL %s: PLAYWRIGHT_MCP_BROWSER=%s, want %s\n' "$name" "$got_browser" "$want_browser" >&2
    failures=$((failures + 1))
  fi
  if [[ ! "$got_package" =~ $want_package ]]; then
    printf 'FAIL %s: package %s, want match for %s\n' "$name" "$got_package" "$want_package" >&2
    failures=$((failures + 1))
  fi
}

pinned='^@playwright/cli@[0-9]+\.[0-9]+\.[0-9]+$'

run_case default chromium "$pinned" ':' open about:blank
run_case env-browser firefox "$pinned" 'export PLAYWRIGHT_MCP_BROWSER=firefox' open
run_case env-config '<unset>' "$pinned" 'export PLAYWRIGHT_MCP_CONFIG=x.json' open
run_case config-flag '<unset>' "$pinned" ':' open --config=x.json
run_case config-flag-split '<unset>' "$pinned" ':' open --config x.json
run_case workspace-config '<unset>' "$pinned" 'mkdir -p .playwright && echo {} > .playwright/cli.config.json' open
# shellcheck disable=SC2016 # $HOME expands inside the case subshell.
run_case global-config '<unset>' "$pinned" 'mkdir -p "$HOME/.playwright" && echo {} > "$HOME/.playwright/cli.config.json"' open
run_case version-override chromium '^@playwright/cli@9\.9\.9$' 'export PLAYWRIGHT_CLI_VERSION=9.9.9' open

if (( failures > 0 )); then
  exit 1
fi
printf 'playwright wrapper launch contract holds\n'
