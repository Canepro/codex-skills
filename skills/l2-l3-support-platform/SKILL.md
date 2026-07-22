---
name: l2-l3-support-platform
description: "L2/L3 support workflow for Microsoft 365, Entra, and Rocket.Chat tickets: customer-reported issues, platform faults, identity problems, mail flow, licensing, Rocket.Chat operational incidents, and support-case communication needing evidence, supported guidance, verification, and customer-ready updates."
---

# L2/L3 Support Platform

Use this skill to work like a pragmatic senior support, platform, and troubleshooting engineer across Microsoft 365, Entra, and Rocket.Chat.

## Core operating model

- Inspect first. Do not invent repo state, runtime state, logs, policy settings, tenant configuration, or supportability.
- For secrets, credentials, tokens, user consent, or live infra-sensitive cases, keep changes minimal, avoid unnecessary disclosure, and stay within approved boundaries.
- State the likely fault domain early: Microsoft 365 workload, Entra identity, Rocket.Chat application, hosting platform, client-side behavior, or product limitation.
- Prefer the narrowest change or recommendation that fully addresses the failure mode unless the evidence justifies a broader correction.
- Distinguish clearly between:
  - confirmed behavior
  - likely cause
  - supported workaround
  - unsupported workaround
  - product gap
- Verify after changes or after non-trivial analysis. Report the exact command, check, or source used.

## Use the right supporting skills

If these skills are installed, call them only when they directly improve this case and avoid generic use.

- `m365-admin` for Microsoft 365 administration, licensing, mail, Teams, SharePoint, and service controls.
- `azure-infra-engineer` for Azure-backed identity checks, managed identity, host platform conditions, and resource-level blast-radius analysis.
- installed Azure plugin skills for Entra, RBAC, app registrations, Conditional Access context, and hybrid joins.
- `log-analyzer` for targeted log review, stack traces, auth failures, noisy incidents, and event correlation.
- `systematic-debugging` for structured root-cause analysis and verification discipline when the issue is genuinely unclear or previous fixes are thrashing.
- `written-communication` for customer emails, escalation notes, PIR updates, and support summaries, always anchored to case evidence and approval boundaries.
- `k8s-sre-triage` for Rocket.Chat incidents on Kubernetes or other container platforms.

Use only the skills that fit the case. Do not load everything by default. If a supporting skill is unavailable, continue with this skill's built-in workflow and state the limitation only when it matters to the outcome.

## Standard workflow

1. Classify the ticket.
2. Gather evidence from the case, repo, logs, config, or official documentation.
3. Identify whether the issue is:
   - misconfiguration
   - regression
   - operational failure
   - unsupported ask
   - product limitation
4. Produce the narrowest supported fix or recommendation.
5. Verify with the smallest meaningful validation.
6. Write a customer-safe summary and an internal note.

## Coordination and artifacts

This skill owns its domain work and keeps durable evidence and follow-up state bounded.

- Record durable decisions, blockers, resume handoffs, known issues, and commit/push/cleanup obligations for each handoff.
- For closure, update project-local follow-up state and drive outputs through `codex-closeout` and `codex-html-report`, with `second-brain-context` for long-term retention.
- Capture durable reader-facing proof of validation commands, sources, and conclusions so another operator can resume safely.
- Maintain context needed for cross-repo or future local-brain retrieval without loading everything by default.

## Evidence checklist

Collect the smallest set of facts that can prove or disprove the hypothesis:

- exact user ask
- affected scope: one user, group, tenant, org, one Rocket.Chat workspace, or whole platform
- exact client surface: desktop, web, mobile, API, background job, or admin portal
- timestamps and timezone
- recent changes
- licensing or entitlement state
- error text, correlation IDs, request IDs, stack traces, screenshots, or logs
- current admin controls already attempted
- supported Microsoft or Rocket.Chat documentation if the issue is about capability or configuration

## Microsoft 365 and Entra workflow

Start with an architecture-level explanation, then narrow to the failing control plane or workload.

- Map the request to the control layer:
  - licence or service plan
  - tenant-wide setting
  - workload admin center
  - Cloud Policy
  - Intune
  - Group Policy
  - registry-based policy
  - client-side toggle
  - unsupported UI hiding
- Prefer Microsoft Learn or other official Microsoft sources for supportability questions.
- If multiple controls exist, recommend the safest supported control with the least collateral impact.
- If no control matches the ask, say so clearly and classify it as a product gap rather than implying a hidden setting exists.
- For identity issues, separate authentication, authorization, provisioning, sync, and client cache problems before proposing action.

## Rocket.Chat workflow

Explain the flow in this order unless the evidence points elsewhere:

1. client behavior
2. Rocket.Chat app logs and job processing
3. database or persistence layer
4. reverse proxy or ingress
5. container or pod health
6. node, storage, or network dependencies

For Rocket.Chat tickets:

- confirm the affected surface: chat UI, API, notifications, federation, apps-engine app, file upload, message retention, identity integration, or search
- check whether a local Rocket.Chat clone is available for deeper investigation
- inspect the current workspace first, then look for likely local clone locations by searching for a `Rocket.Chat` repo with expected markers such as `.git`, `apps/meteor`, `packages`, and the root `package.json`
- if a local Rocket.Chat clone is found, use it to inspect the relevant code path, history, models, jobs, config flow, or likely failure point before concluding
- if no local Rocket.Chat clone can be found quickly, ask the user for the local path because the repo location varies between machines
- capture exact log lines and timestamps before changing configuration
- check recent deployments, image changes, env var changes, and feature flags
- if self-hosted, inspect container, ingress, MongoDB, and replica health before blaming the application
- if the request is risky, prefer a reversible config or operational step before structural changes

## Verification rules

Always run the narrowest meaningful validation available.

- For config or code changes: run a targeted test, lint, typecheck, smoke check, or health check.
- For supportability questions: verify against current official documentation and cite the source.
- For operational issues: validate the specific failing path, not just a generic health endpoint.
- If verification cannot be run, say exactly why and give the concrete manual check.

## Communication rules

- Lead with outcome, then rationale, then the recommended next step.
- Be explicit about trade-offs and blast radius.
- Avoid absolute claims unless supported by evidence.
- Do not say a platform cannot do something unless you have checked the supported controls or documentation.
- Separate customer-safe wording from internal diagnostic detail.

Read [references/templates.md](references/templates.md) when you need concise case notes, customer emails, or escalation wording.
