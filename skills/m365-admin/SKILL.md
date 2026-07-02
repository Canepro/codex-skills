---
name: m365-admin
description: "Administer and automate Microsoft 365: Exchange Online mailboxes, Teams lifecycle, SharePoint sites and sharing, license auditing, and Graph API or PowerShell automation. Use for admin scripting, onboarding/offboarding workflows, and tenant configuration. Customer-ticket investigation routes to l2-l3-support-platform."
---

# Microsoft 365 Administrator

## Purpose

Administer and automate Microsoft 365 workloads through PowerShell and the Graph API: Exchange Online, Teams, SharePoint, licensing, and identity. The skill designs, builds, and reviews admin scripts and workflows with least-privilege access and verified results.

## When to Use

- Exchange Online mailbox management and lifecycle
- Microsoft Teams team lifecycle automation
- SharePoint site management, permissions, and sharing settings
- License assignment, auditing, and optimization
- Microsoft Graph PowerShell automation
- User provisioning, onboarding, and offboarding workflows
- Compliance and security configuration
- Guest access and external sharing management

Customer-reported tickets and support-case triage belong to `l2-l3-support-platform`; use this skill for the admin and automation work that investigation surfaces.

## Procedure

Run every admin task through these steps. Do not skip validation or verification.

### 1. Connect

- Pick the right surface: `Connect-MgGraph` for identity, licensing, Teams, and SharePoint via Graph; `Connect-ExchangeOnline` for mailbox and transport work.
- Read `references/m365_quickstart.md` before the first Graph connection in a session; it covers app registration, authentication, and common connection failures.
- Request only the scopes the task needs (for example `Connect-MgGraph -Scopes "User.Read.All"`), not broad admin scopes by habit.

### 2. Validate permissions and consent

- Confirm the connected account or app registration holds the required roles or Graph permissions before proposing changes.
- Choose delegated, application, resource-specific consent, or workload-specific controls by scenario. Prefer the narrowest permission that can prove the task. App-only permissions are tenant-wide grants unless constrained by the workload and admin consent.
- If consent for a new permission is needed, name the exact permission and let the user grant it; do not widen an existing grant silently.

### 3. Dry-run first

- Use `-WhatIf` on every cmdlet that supports it before the real run.
- For Graph calls without a dry-run mode, run the read query first and show the affected object list for confirmation.
- For bulk changes, run against one test object or a small batch before the full set, and capture the current state of affected objects so the change can be reversed.

### 4. Execute

- Run the change with error handling: try/catch around each operation, log failures with object identity and error text.
- Batch Graph calls for bulk operations and handle throttling with retry and backoff.
- Keep secrets, credentials, tokens, and private key material out of scripts and logs. Store and retrieve values through Infisical and keep proof records redacted.

### 5. Verify

- Re-read the changed objects and confirm the intended state, not just a zero exit code.
- For mail flow or policy changes, run the narrowest live check available (message trace, test user sign-in, policy readback).

### 6. Report

- Summarize what changed, the evidence commands run, objects affected, and any failures or skipped objects.
- Include rollback steps for bulk or destructive changes.

## Tool Restrictions

- Read: Access `scripts/create_m365_users.ts`, `scripts/configure_teams.ts`, `scripts/setup_exchange.ts`, `references/m365_quickstart.md`, and `references/admin_patterns.md` before proposing changes
- Write/Edit: Create or modify PowerShell and TypeScript automation files in `scripts/`
- Bash: Execute commands with evidence output such as `Connect-ExchangeOnline`, `Connect-MgGraph`, `Get-EXOMailbox`, `Get-MgUser`, and `Get-MgGroup`
- Glob/Grep: Search with concrete patterns like `rg -n "M365|Graph|ExchangeOnline|Teams"`

## Integration with Other Skills

- `l2-l3-support-platform`: customer-facing Microsoft 365, Entra, or support-case triage and escalation
- installed Azure plugin skills: Entra identity, RBAC, hybrid alignment, and Azure-side infrastructure
- installed Codex Security plugin skills: security compliance, least-privilege review, and access-review hardening
- installed Superpowers `systematic-debugging`: root-cause discipline when Graph, Exchange, Teams, or SharePoint behavior is unclear and prior attempts are thrashing
- `ci-pipeline-triage`: CI or automation pipeline failures around M365 scripts

## Scenario Walkthroughs

### Onboarding automation

"Automate new employee onboarding with mailbox, Teams, and license assignment."

Apply the procedure: connect to Graph with directory and license scopes, validate the app grant, then build a script that creates the user, assigns licenses by role, provisions the mailbox, adds the user to the departmental Team, distribution groups, and SharePoint sites, and sends a welcome message. Dry-run against a test account, execute, verify each provisioned object, and report the workflow with error handling and logging included.

### SharePoint external sharing audit

"Audit all SharePoint sites for external sharing and fix misconfigured sites."

Read all site sharing settings via Graph, classify sites against policy, and report owners, current settings, and external users per site. Remediate with a script that disables external sharing on non-compliant sites, dry-running the change list with the user first, then verify the new settings and set up recurring monitoring.

### License optimization

"Audit and optimize M365 licenses across the organization."

Query assigned licenses and sign-in activity via Graph, identify unused licenses and over-licensed users, and produce a reclamation plan for the user to approve. Execute reassignment in batches with verification per batch, then add an automated assignment workflow so drift does not return.

## Best Practices

- Least privilege: apply RBAC principles for all automation accounts; conduct regular access reviews to prevent permission creep
- Testing: always test scripts in non-production or against test accounts first
- Backup: audit and record the state of affected objects before bulk changes
- Error handling: try/catch on all operations with logging that supports audit trails
- Conditional Access: require it for sensitive operations; enable unified audit logging
- Secrets: never hardcode credentials; route values through Infisical and keep proof output redacted
- Performance: batch API calls, handle throttling gracefully, parallelize only independent operations
- Approval: include approval workflows for high-impact changes

## Anti-Patterns

- No error handling: scripts that fail silently; wrap operations in try/catch/finally
- Hardcoded values: usernames, URLs, or credentials embedded in scripts; use parameters and secure storage
- Chatty API calls: excessive per-object requests; batch operations and use delta queries
- Over-privileged accounts: admin accounts for routine tasks; apply least privilege
- Manual provisioning: creating users by hand when the lifecycle should be automated
- Orphaned accounts: no deprovisioning after departure; automate offboarding
- License waste: assigning licenses without usage tracking
- Configuration drift and policy overlap: environments diverging or conflicting policies accumulating; consolidate and manage configuration as code

## Scripts and References

Load these on condition, not all upfront:

- `references/m365_quickstart.md`: read before the first Graph or Exchange connection in a session (app registration, authentication, troubleshooting)
- `references/admin_patterns.md`: read when designing a multi-step workflow (user lifecycle, Teams templates, email automation, license management, backup and recovery patterns)
- `scripts/create_m365_users.ts`: read before user lifecycle or bulk user work (user creation, license assignment, password validation, bulk operations)
- `scripts/configure_teams.ts`: read before Teams automation (team creation, channels, membership, settings, archiving)
- `scripts/setup_exchange.ts`: read before Exchange automation (mailboxes, auto-reply, distribution groups, calendar, mail automation)

## Workflow Coordination

This skill owns Microsoft 365 administration and automation work. It does not own general workflow state.

Use `vincent-workflow` for durable decisions, blockers, resume handoffs, known issues, commit/push/cleanup obligations, or project-local follow-up state.
Use `codex-closeout` for final chat delivery.
Use `codex-html-report` for durable reader-facing proof.
Use `second-brain-context` only when the lesson should survive across repos, agents, or future local-brain retrieval.
