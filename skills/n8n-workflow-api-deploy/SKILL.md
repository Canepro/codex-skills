---
name: n8n-workflow-api-deploy
description: Deploy, update, inspect, and verify n8n workflows through the n8n API. Use when creating or changing n8n workflow JSON, upserting workflows, binding credentials, checking live workflow drift, validating node URLs, keeping automations inactive until activation gates pass, or debugging n8n API/runtime mismatch.
---

# n8n Workflow API Deploy

Use this skill when n8n workflow state must match source-controlled workflow JSON. Treat live n8n readback as the proof surface. Static JSON validation is useful, but it is not enough for a demo or activation gate.

Mandatory triggers: load this skill before direct n8n API calls, workflow upserts, live workflow reads, execution-history checks, credential binding verification, public API capability research, or debugging a mismatch between workflow JSON and live n8n behavior. If a public API key can update workflows but returns `403` for credential metadata, keep going through safe workflow-node binding proof instead of trying to read credential secrets.

## Workflow

1. Identify the source workflow JSON, target workflow name, and target environment.
2. Validate static invariants before touching n8n:
   - expected node names exist
   - workflow export is inactive unless activation is explicitly approved
   - HTTP nodes use the intended paths, not service roots
   - no placeholder credential ids, org ids, tokens, or hostnames remain
   - customer-facing send nodes are absent unless explicitly approved
3. Upsert through the n8n API using a script or structured API request, not manual copy/paste. Before update, read the live workflow and preserve live metadata by merging source changes with existing n8n-owned `settings` and `tags` values so updates do not overwrite operational fields.
4. Read the live workflow back from n8n by id or name.
5. Compare live state to the intended state:
   - workflow name and active flag
   - critical node URLs and HTTP methods
   - n8n-owned `settings` and `tags` preserved unless the contract explicitly changes them
   - credential bindings present by type and expected display name, without printing secret values
   - required headers present, especially org or auth headers
   - code nodes contain the intended operator inputs or placeholders
6. Run an execution check when credentials and a safe fixture are available. Capture the execution `id`, `failed node`, and `error` details from the run output so failures can be traced to a node.
7. Record proof as redacted JSON or a short report: workflow ids, execution id, failed node, error, active flags, node checks, HTTP status, and execution result.

## Safety rules

- Never print n8n API keys, credential payloads, OAuth refresh tokens, cookies, or bearer tokens.
- Keep workflow activation separate from import/update. Activation is a release step with its own gate.
- Prefer inactive-by-default for new workflows and webhook automations.
- Treat browser UI state as advisory. API readback is the authoritative deployed state.
- If the live workflow differs from source-controlled JSON, either update n8n from source or update source from live state. Do not leave drift unrecorded.

## Common failure modes

`Cannot POST /`: an HTTP Request node is pointed at a service root instead of the real route. Fix the URL normalizer and read the live workflow back.

`403` from the n8n API: the API key can read or update some resources but not credential metadata. Validate credential binding presence through workflow nodes without reading credential secrets.

Webhook tests pass but production fails: the workflow may be inactive, the webhook URL may differ between test and production mode, or the payload shape may differ. Capture the actual incoming payload before changing logic.

Static checks pass but live run fails: check live node URLs, active state, credential ids, environment variables, execution id, and whether the workflow was run from the first node or only a final HTTP node. Record which failed node and error diagnostics were returned.

## Done means

- Static validation passed.
- Live n8n readback confirms the intended node URLs, credentials, active flags, and headers.
- A safe execution check ran or a concrete blocker is recorded.
- The workflow activation state is intentional.
- Proof is redacted and durable enough for the next operator.

## Workflow coordination

Use `infisical-secrets-management` before consuming n8n API keys or service tokens. Use repo-local skills such as `support-agent-ops` for project-specific workflow contracts. Use `vincent-workflow` when the change creates durable decisions, blockers, handoffs, or commit/push obligations. Use `codex-closeout` for end-of-work proof hygiene. Use `codex-html-report` when the deployment proof should become a reader-facing artifact.
