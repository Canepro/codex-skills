---
name: codex-mcp-repair
description: "Use when local Codex MCP or connector setup fails, including Zoho MCP, streamable_http auth, stdio wrappers, mcp-remote, malformed local state, startup warnings, missing features, or add/fix this MCP in Codex tasks. Preserve endpoints the user says work elsewhere; troubleshoot local Codex auth, transport, wrapper, and state first."
---

# Codex MCP Repair

Use this for machine-local Codex MCP troubleshooting and setup. Keep changes additive and local unless the user asks for broader cleanup.

## First Shape Check

Start with:

```bash
codex mcp get <name>
```

Then decide:

- `streamable_http` with reachable endpoint but auth failure: use `codex mcp login <name>`.
- `streamable_http` with OAuth and stale-token errors such as `invalid_grant` or `Invalid refresh token`: run `codex mcp logout <name>` and then `codex mcp login <name>` before changing config.
- stdio wrapper or `mcp-remote` setup: inspect wrapper command, args, env, and local executable availability.
- startup warning/state errors: treat each warning as a separate issue unless evidence ties them together.

## Preservation Rule

If the user says an MCP/server setup already works elsewhere or cannot be changed, do not edit the upstream endpoint by default. Repair the local Codex side:

- auth/login state
- transport type
- wrapper command
- local config syntax
- local database/state corruption
- plugin or connector gating

## Common Zoho Shape

For Zoho-style MCP failures, the known working pattern may be a stdio wrapper using `mcp-remote` against Zoho's canonical `/mcp/<key>/message` path. Verify current local config before changing it.

## Common OAuth Shape

For OAuth MCP servers such as Cloudflare, if `codex mcp get <name>` shows the expected URL and `Auth: OAuth`, prefer a local auth refresh over endpoint edits:

```bash
codex mcp logout <name>
codex mcp login <name>
codex doctor
```

If a skills-context-budget warning appears beside an MCP auth failure, classify it separately unless it is the command that actually failed. Do not let prompt-budget noise redirect an auth repair.

## Install Channel Check

For Codex update confusion or a stale-version symptom, check the active install channel before retrying installs. `which -a codex` can show the standalone `~/.local/bin/codex`, npm or Homebrew shims, and the app-bundled CLI at the same time. On this Mac the expected active path is the standalone runtime:

```bash
which -a codex
codex update
codex app-server daemon restart
codex app-server daemon version
```

Run `codex doctor` after any config change, not only OAuth repairs.

## Output

Report:

- original symptom
- config shape found
- change made
- verification command and result
- any remaining warning treated separately

Do not paste credentials, bearer tokens, OAuth state, or secret paths into chat beyond the minimum safe path names needed to explain the fix.

## Workflow Coordination

This skill owns Codex MCP repair diagnosis and local auth/config recovery. Use `vincent-workflow` for durable blockers, decisions, handoffs, known issues, and commit/push/cleanup state when a repo or local automation is changed. Use `codex-html-report` for durable incident proof when the repair spans multiple surfaces. Use `codex-closeout` for final chat delivery. Keep OAuth state, tokens, and secret paths out of workflow records.
