---
name: entra-oidc-app-integration
description: "Microsoft Entra OIDC app integrations with Argo CD, Grafana, Kubernetes dashboards, or CI/CD tools: app registrations, redirect URIs, client secrets, group claims, RBAC group mapping, and SSO cutover verification. Not for general Microsoft 365 tenant administration (m365-admin)."
---

# Entra OIDC App Integration

Use this skill for Microsoft Entra app registration and OIDC SSO work, especially
when an app needs an Entra login button, group-based RBAC, a client secret, or a
safe cutover from local admin to SSO.

## Routing

- Use Azure MCP/plugin best-practices for Entra/Azure operations before changing
  Azure/Entra resources.
- Use `infisical-secrets-management` before reading, writing, rotating, staging,
  or injecting any client secret value.
- Use repo-native runbooks/source when they exist. Do not invent a parallel
  authority path for GitOps-managed config.

## Safety Boundary

- Treat app IDs, tenant IDs, issuer URLs, redirect URIs, and group object IDs as
  non-secret but still avoid overexposing them in public docs.
- Treat client secrets, secret IDs when operationally sensitive, refresh tokens,
  OAuth state, cookies, kubeconfigs, and service tokens as secret-value material.
- Do not print, commit, screenshot, paste, or log secret values.
- If a value must be materialized locally, use `mktemp`, `umask 077`, no shell
  tracing, and delete it with `trap`.
- Keep local/break-glass admin enabled until SSO login and admin access are
  proven in the browser.
- Disable local admin only as a separate approved change.

## Entra App Checklist

For a typical confidential web app:

- `signInAudience=AzureADMyOrg` unless multi-tenant access is explicitly needed.
- Redirect URI exactly matches the app callback, for example
  `https://<host>/auth/callback`.
- ID token issuance enabled when the app needs OIDC login.
- Access token implicit grant disabled unless the app explicitly requires it.
- `groupMembershipClaims=SecurityGroup` when RBAC depends on Entra security
  group claims.
- Operator account is in the intended admin group before cutover.
- Client secret is rotated/staged through the approved secret manager, not typed
  into config files.

Metadata-only checks:

```bash
az ad app show \
  --id <client-id> \
  --query '{displayName:displayName,appId:appId,signInAudience:signInAudience,groupMembershipClaims:groupMembershipClaims,redirectUris:web.redirectUris,implicitGrant:web.implicitGrantSettings}' \
  -o json

az ad group member check \
  --group <admin-group-object-id> \
  --member-id <operator-user-object-id> \
  -o json
```

## Scopes And Group Claims

Do not request `groups` as an OAuth scope for Microsoft Entra unless the target
resource explicitly exposes such a scope. For normal Entra OIDC app login:

- Requested scopes are usually `openid`, `profile`, and `email`.
- Group membership is emitted as a token claim because the app registration has
  `groupMembershipClaims=SecurityGroup`.
- The consuming app may still need a local setting telling it to read the
  `groups` claim. For Argo CD this is `argocd-rbac-cm` `scopes: '[groups]'`.

If Entra returns `AADSTS650053` for scope `groups`, remove `groups` from
requested OAuth scopes and keep group-claim/RBAC handling in the app config.

## Client Secret Handling Pattern

Generate and stage the secret value without printing it:

```bash
SECRET_FILE="$(mktemp)"
trap 'rm -f "$SECRET_FILE"' EXIT
umask 077

az ad app credential reset \
  --id <client-id> \
  --append \
  --display-name "<rotation-label>" \
  --years 1 \
  --query password -o tsv | tr -d '\r\n' > "$SECRET_FILE"

# Store through the approved secret manager. Example only; use repo-local path.
infisical secrets set "<SECRET_NAME>=@${SECRET_FILE}" \
  --env <env> \
  --path <path> \
  --projectId <project-id> \
  --silent >/dev/null
```

Important:

- Use the client secret value, not the secret ID.
- Strip trailing newlines before injecting into consumers.
- Prefer `--from-literal` for Kubernetes secret keys when the source value is a
  single credential string.

## Argo CD Specifics

When Argo CD uses `clientSecret: $<secret-name>:<key>`:

- The Kubernetes secret must be in the `argocd` namespace.
- It must have label `app.kubernetes.io/part-of=argocd`.
- The referenced key must exist, for example `clientSecret`.
- Restart or roll `argocd-server` after changing OIDC config or secret value.

Shape-only verification:

```bash
kubectl -n argocd get secret <secret-name> -o json |
  jq -r '{name:.metadata.name,labels:.metadata.labels,has_clientSecret:(.data|has("clientSecret")),clientSecret_b64_len:(.data.clientSecret|length)}'
```

If Entra returns `AADSTS7000215`, check:

- secret value vs secret ID
- trailing newline in the stored value
- missing Argo label on the Kubernetes secret
- app registration/client ID mismatch
- old `argocd-server` pod still holding stale config

## Public Repo Hygiene

In public repos:

- Keep deployment-required non-secret identifiers in source only where needed.
- Prefer placeholders in prose runbooks for tenant IDs, client IDs, group object
  IDs, secret-manager paths, and human account object IDs.
- Never include secret values, secret IDs, OAuth state, screenshots with tokens,
  raw curl/browser callback dumps, private Infisical paths, or user object IDs in
  committed docs unless there is an explicit public-disclosure reason.

## Verification Closeout

Before calling the work done:

- App registration metadata matches expected redirect URI and group claim mode.
- Secret exists in the approved secret manager and live consumer, without value
  disclosure.
- App config requests valid OAuth scopes only.
- RBAC maps the exact intended group claim.
- Local/break-glass admin remains enabled until browser SSO is proven.
- Browser login succeeds and admin access is confirmed.
- Source, live state, and runbook agree.
- Follow-up to disable local admin is separate and reversible.

## Workflow Coordination

This skill owns Entra OIDC integration, app-registration checks, and SSO proof. Use `infisical-secrets-management` for secret inventory, staging, injection, rotation, and redacted proof. Use `vincent-workflow` for durable decisions, blockers, handoffs, known issues, and commit/push/cleanup state. Use `browser-form-privacy-flow` for browser login or admin-console actions with sensitive fields. Use `codex-html-report` for durable integration proof and `codex-closeout` for final chat delivery.
