---
name: "playwright"
description: "Fallback terminal browser automation using `playwright-cli` or the bundled wrapper. Use when Browser/Chrome plugin control is unavailable or the task needs CLI-friendly navigation, form filling, screenshots, snapshots, scraping, or stateful browser workflows. Do not use as the first route when vendor frontend testing, visual QA, or browser plugin tools are available; use those first."
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

# If missing, install Node.js/npm, then:
npm install -g @playwright/mcp@latest
playwright-cli --help
```

Once `npx` is present, proceed with the wrapper script. A global install of `playwright-cli` is optional.

## Skill path (set once)

```bash
export CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
export PWCLI="$CODEX_HOME/skills/playwright/scripts/playwright_cli.sh"
```

User-scoped skills install under `$CODEX_HOME/skills` (default: `~/.codex/skills`).

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

If the user prefers a global install, use the install commands from the prerequisite check above; a global install stays optional.

## Core workflow

1. Open the page (or attach to the existing session).
2. Snapshot to get stable element refs.
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
- clicking elements that change the UI substantially
- opening/closing modals or menus
- tab switches

Refs can go stale. When a command fails due to a missing ref, snapshot again.

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

The wrapper script uses `npx --package @playwright/mcp playwright-cli` so the CLI can run without a global install:

```bash
"$PWCLI" --help
```

Prefer the wrapper unless the repository already standardizes on a global install.

## References

Open only what you need:

- CLI command reference: `references/cli.md`
- Practical workflows and troubleshooting: `references/workflows.md`

## Stateful sessions

The browser session keeps page state across commands, so multi-step flows (login, wizards, data that appears only after interaction) work without re-driving earlier steps. Keep the same session alive while navigating, clicking, filling, and capturing evidence. Collect concrete evidence by recording command outputs and artifact paths with timestamps. Extract only the data the user asked for instead of dumping whole pages, and apply the redaction guardrail below to everything you share.

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

## Workflow Coordination

This skill owns its domain work. Use `vincent-workflow` for durable decisions, blockers, resume handoffs, known issues, commit/push/cleanup obligations, or project-local follow-up state. Use `codex-closeout` for final chat delivery, `codex-html-report` for durable reader-facing proof, and `second-brain-context` only for cross-repo or future local-brain retrieval.
