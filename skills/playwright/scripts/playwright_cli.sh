#!/usr/bin/env bash
set -euo pipefail

# Pin the CLI so the browser build it expects is known and stays the same
# across hosts. Each @playwright/cli release bundles one Playwright version,
# and each Playwright version launches exactly one Chromium revision. When you
# bump this pin, run `install-browser chromium` through this wrapper.
PLAYWRIGHT_CLI_VERSION="${PLAYWRIGHT_CLI_VERSION:-0.1.22}"

if ! command -v npx >/dev/null 2>&1; then
  echo "Error: npx is required but not found on PATH." >&2
  exit 1
fi

has_session_flag="false"
has_config_flag="false"
for arg in "$@"; do
  case "$arg" in
    --session|--session=*)
      has_session_flag="true"
      ;;
    --config|--config=*)
      has_config_flag="true"
      ;;
  esac
done

# The CLI defaults to the Google Chrome channel, which needs a system Chrome
# install and does not exist on every host (Linux arm64 has none). Default to
# Playwright's own Chromium build, installed by `install-browser chromium` for
# the pinned CLI. A --browser flag still wins. PLAYWRIGHT_MCP_BROWSER, a
# --config flag, PLAYWRIGHT_MCP_CONFIG, or a CLI config file keeps its own
# choice, because this env default would otherwise override the file.
if [[ -z "${PLAYWRIGHT_MCP_BROWSER:-}" && -z "${PLAYWRIGHT_MCP_CONFIG:-}" &&
  "${has_config_flag}" != "true" &&
  ! -f ".playwright/cli.config.json" &&
  ! -f "${HOME}/.playwright/cli.config.json" ]]; then
  export PLAYWRIGHT_MCP_BROWSER="chromium"
fi

# `playwright-cli` is provided by `@playwright/cli` (client for Playwright MCP).
# `@playwright/mcp` provides the server binary (`playwright-mcp`), not the CLI client.
# --prefer-offline reuses the cached copy of an exact pin without a registry
# round trip, so an offline host does not stall on npm retries.
cmd=(npx --yes --prefer-offline --package "@playwright/cli@${PLAYWRIGHT_CLI_VERSION}" playwright-cli)
if [[ "${has_session_flag}" != "true" && -n "${PLAYWRIGHT_CLI_SESSION:-}" ]]; then
  cmd+=(--session "${PLAYWRIGHT_CLI_SESSION}")
fi
cmd+=("$@")

exec "${cmd[@]}"
