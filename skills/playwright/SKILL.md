---
name: "playwright"
description: "Fallback terminal browser automation via playwright-cli or the bundled wrapper. Use when Browser/Chrome plugin control is unavailable or the task needs CLI-friendly navigation, form filling, screenshots, scraping, or stateful browser sessions. Vendor frontend-testing and browser plugin tools route first."
---


# Playwright CLI Skill

Drive a real browser from the terminal using `playwright-cli`. Prefer Browser/Chrome plugin control when the current Codex surface provides it, and prefer vendor frontend or data visualization testing skills for UI QA. Use this skill when a terminal-controlled browser is the right fallback or the repo needs CLI-reproducible browser steps.
Prefer the bundled wrapper script so the CLI works even when it is not globally installed.
Treat this skill as CLI-first automation. Do not pivot to `@playwright/test` unless the user explicitly asks for test files.

## Prerequisite check (required)

Before proposing commands, check whether `npx` is available (the wrapper depends on it):

```bash
command -v npx >/dev/null 2>&1
```

If it is not available, pause and ask the user to install Node.js/npm (which provides `npx`). Provide these steps verbatim:

```bash
# Verify Node/npm are installed
node --version
npm --version
```

Once `npx` is present, proceed with the wrapper script. Skip a global `playwright-cli` install: it bypasses the wrapper's pinned CLI version and Chromium default.

## Skill path (set once)

```bash
for d in "$HOME/.agents/skills" "$HOME/.claude/skills" "${CODEX_HOME:-$HOME/.codex}/skills"; do
  [ -x "$d/playwright/scripts/playwright_cli.sh" ] && export PWCLI="$d/playwright/scripts/playwright_cli.sh" && break
done
```

User-scoped skills install under `~/.agents/skills` (Codex), `~/.claude/skills` (Claude Code), or `$CODEX_HOME/skills`.

## Verify the route (once per host or pin bump)

The wrapper pins `@playwright/cli` and defaults to Playwright's own Chromium build, so the CLI version and the browser revision match. Check that the matching browser is installed:

```bash
"$PWCLI" --version
"$PWCLI" -s=pwcheck open about:blank && "$PWCLI" -s=pwcheck close
```

If `open` reports that a browser is not installed or names a missing `chromium-<revision>` path, install the build for the pinned CLI with Playwright's installer, then rerun the check:

```bash
"$PWCLI" install-browser chromium
```

The CLI may suggest `install-browser chrome-for-testing`, which is the same build. Pass a browser name explicitly; a bare `install-browser` downloads every browser. When the host is offline, report the missing revision instead of retrying. Do not point `--executable-path` at another revision as the default route.

## Quick start

Use the wrapper script:

```bash
"$PWCLI" open https://playwright.dev --headed
"$PWCLI" snapshot
"$PWCLI" click e15
"$PWCLI" type "Playwright"
"$PWCLI" press Enter
"$PWCLI" screenshot
```

Run the route check in "Verify the route" before the first session on a host.

## Core workflow

1. Start with a clean session when prior page state or cookies could change the result. Use the existing session only when that state is intentionally required.
2. Wait for dynamic content to settle, then snapshot to get stable element refs.
3. Interact using refs from the latest snapshot.
4. Re-snapshot after navigation or significant DOM changes.
5. Collect concrete evidence with command output and file path references before and after critical steps.
6. Capture artifacts (screenshot, pdf, traces) when useful.

Minimal loop:

```bash
"$PWCLI" open https://example.com
"$PWCLI" snapshot
"$PWCLI" click e3
"$PWCLI" snapshot
```

## When to snapshot again

Snapshot again after:

- navigation
- dynamic content updates that are still settling
- clicking elements that change the UI substantially
- opening/closing modals or menus
- tab switches

Refs can go stale. When a command fails due to a missing ref, wait for dynamic content to settle, then snapshot again.

## Recommended patterns

### Form fill and submit

```bash
"$PWCLI" open https://example.com/form
"$PWCLI" snapshot
"$PWCLI" fill e1 "user@example.com"
"$PWCLI" fill e2 "password123"
"$PWCLI" click e3
"$PWCLI" snapshot
```

### Debug a UI flow with traces

```bash
"$PWCLI" open https://example.com --headed
"$PWCLI" tracing-start
# ...interactions...
"$PWCLI" tracing-stop
```

### Multi-tab work

```bash
"$PWCLI" tab-new https://example.com
"$PWCLI" tab-list
"$PWCLI" tab-select 0
"$PWCLI" snapshot
```

## Wrapper script

The wrapper runs `npx --yes --prefer-offline --package @playwright/cli@<pinned> playwright-cli`, so the CLI runs without a global install. It sets `PLAYWRIGHT_MCP_BROWSER=chromium` unless you pass `--browser` or `--config`, set `PLAYWRIGHT_MCP_BROWSER` or `PLAYWRIGHT_MCP_CONFIG`, or a `.playwright/cli.config.json` exists in the working directory or home directory. It adds `--session "$PLAYWRIGHT_CLI_SESSION"` when that variable is set, except for `install` and `install-browser`. `PLAYWRIGHT_CLI_VERSION` overrides the pin; rerun the route check after changing it.

```bash
"$PWCLI" --help
```

Prefer the wrapper unless the repository already standardizes on a global install.

## References

Open only what you need:

- CLI command reference: `references/cli.md`
- Practical workflows and troubleshooting: `references/workflows.md`

## Stateful sessions

The browser session keeps page state across commands, so multi-step flows (login, wizards, data that appears only after interaction) work without re-driving earlier steps. If previous cookies or prior state could bias the result, start from a clean session first. If state is required, keep the same session alive while navigating, clicking, filling, and capturing evidence. Collect concrete evidence by recording command outputs and artifact paths with timestamps. Extract only the data the user asked for instead of dumping whole pages, and apply the redaction guardrail below to everything you share.

## Guardrails

- Name the actor behind each action (user, operator, agent) so authority boundaries stay explicit.
- Do not invent credentials. Reuse the existing session or the user's normal login flow when auth is required.
- Do not echo, store, or share raw `secret` or `credential` values. Redact sensitive fields in command output, logs, screenshots, traces, and pasted snippets.
- Use this skill when verifying a browser-native HTML report render or screenshot. When verifying browser-native HTML templates or report interactions, load the installed Playwright skill before falling back to manual checks.
- Before final submission or any irreversible action (publish, payment, account changes), pause before final submission and request explicit user confirmation.
- Always snapshot before referencing element ids like `e12`.
- Re-snapshot when refs seem stale.
- Prefer explicit commands over `eval` and `run-code` unless needed.
- When you do not have a fresh snapshot, stop, take a new snapshot, and use the real refs from it. Never guess refs and never bypass refs with `run-code`.
- Use `--headed` when a visual check will help.
- When capturing artifacts in this repo, use `output/playwright/` and avoid introducing new top-level artifact folders.
- Default to CLI commands and workflows, not Playwright test specs.
