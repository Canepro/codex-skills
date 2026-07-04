---
name: vendor-security-gitops-patch
description: Use when a vendor security email, CVE, GHSA, or advisory says a self-hosted or pinned dependency needs a patch and the fix should land through GitOps, Helm values, image tags, container tags, or version-pinned manifests.
metadata:
  short-description: Turn vendor security advisories into safe GitOps patches
---

# Vendor Security GitOps Patch

Use this skill when a vendor security advisory needs to become a scoped GitOps
patch, especially for self-hosted services pinned by Helm values, Argo CD, Flux,
Kustomize, raw manifests, Docker image tags, or version ledgers.

The job is to move from "security email says upgrade" to a verified patch
branch without accidentally rolling production or making a bigger upgrade than
the advisory requires. The expected output is a verified patch branch plus
proof that the chosen target matches the advisory.

## Routing

Use this skill for:

- vendor emails or newsletters announcing vulnerability patches
- CVE, GHSA, HackerOne, NVD, or vendor advisory triage that names fixed versions
- self-hosted or pinned dependencies where the repo owns the deployed version
- GitOps, Helm, Argo CD, Flux, Kustomize, Docker image tag, VEX, SBOM, or version-ledger updates
- deciding whether to stay on the current patch line or move major/minor lines

Pair with:

- `adversary-informed-defense` for CVE/exposure triage, exploitability framing,
  attacker preconditions, and patch priority.
- `rocketchat-kubernetes-triage` for Kubernetes runtime rollout and cluster-impact review.
- the relevant workload-specific runtime triage skill for Helm/Kubernetes
  runtime, chart, Argo CD, and cluster-specific proof.
- `gitops-reconcile` only after a controller convergence failure exists.
- `mira-review-gate` before merging or pushing to an auto-sync production line.
- `vincent-workflow` for durable state, commit/push/cleanup, blockers, and
  approval boundaries.

## Workflow

1. **Capture the advisory**
   - Read the original email/thread when available; do not rely only on a
     forwarded summary.
   - Record sender, subject, received time, affected product, named issues,
     affected ranges, fixed versions, and recommended target.
   - Treat links in email as hints. Verify with primary sources.

2. **Verify from primary sources**
   - Prefer vendor release notes, vendor security advisories, GitHub Security Advisories, official CVE List JSON, NVD, and upstream PRs.
   - Compare publish dates and patch versions.
   - If source wording is delayed or redacted, say what is confirmed and what is
     inferred from release notes or version floors.

3. **Decide the narrow target**
   - Identify the currently pinned repo version and, if reachable, the live
     runtime version.
   - Reject prerelease, alpha, beta, RC, and nightly candidate versions unless
     the advisory explicitly names that prerelease target as fixed.
   - Prefer the latest patched release in the current supported patch line when
     the advisory says that is acceptable.
   - Use a guard for version candidates matching `\b(alpha|beta|rc|nightly|prerelease)\b`.
   - Widen to a minor/major upgrade only when the current line lacks a fix,
     support policy requires it, or compatibility evidence says the wider move
     is safer.
   - Check database, chart, runtime, app, and API compatibility before editing.

4. **Patch the source of truth**
   - Update the narrowest version source: Helm values, Kustomize image tag,
     manifest image, lockfile, or package pin.
   - Update version ledgers, VEX, SBOM, changelog, or advisory references when
     the repo has them.
   - Keep unrelated version churn out of the patch.

5. **Run deterministic proof**
   - Parse changed YAML/JSON/TOML files.
   - Render Helm/Kustomize/manifests using the exact chart or base version when
     possible.
   - Extract every rendered `containers`, `initContainers`, and hook/job image.
   - For advisories touching multiple images or components, map every affected
     component to its current version and target version, then provide registry
     proof for each changed image.
   - Verify each changed image tag exists in its registry using `crane`,
     `skopeo`, Docker Registry v2, or another deterministic registry tool.
   - Run repo-local lint, policy, schema, and diff checks.

6. **Gate deployment**
   - Commit the scoped patch when validation passes and the work is separable.
   - Push a branch when approved or when the repo policy expects branch review.
   - For auto-sync GitOps branches, treat merge/push to the tracked branch as a deployment action.
   - Stop before merge, controller sync, prune, rollout restart, or direct live mutation unless the user explicitly approves that target in the current turn.

## Rendered Image Registry Proof

Use rendered manifests, not only the edited values file. Helm charts often
derive extra image names for microservices, jobs, tests, and hooks.

Example pattern:

```bash
helm template <release> <chart> --version <chart-version> -n <namespace> -f values.yaml \
  | yq -r '.. | select(has("image")) | .image' \
  | sort -u
```

For Docker Hub images:

```bash
repo="rocketchat/account-service"
tag="8.2.6"
token="$(curl -fsS "https://auth.docker.io/token?service=registry.docker.io&scope=repository:${repo}:pull" | jq -r .token)"
curl -fsSI \
  -H "Authorization: Bearer ${token}" \
  -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
  "https://registry-1.docker.io/v2/${repo}/manifests/${tag}"
```

If the registry is not Docker Hub, derive the registry endpoint from the image reference rather than defaulting to Docker Hub.

## Output

Report:

- advisory source and confirmed affected/fixed range
- current pinned version and selected target
- files changed
- deterministic checks run and results
- runtime verification status, including why it was skipped or blocked
- commit, branch, push, merge, and deployment status
- exact approval needed for the next authority-changing step

## Stop Gates

Stop before:

- secret-value handling, credential movement, or token reads
- provider token rotation, service-token creation, or consumer cutover
- pushing directly to an auto-sync production branch
- merging into a GitOps-tracked branch
- Argo CD or Flux sync, prune, force, rollback, delete, or refresh that changes
  live state
- direct `kubectl apply`, `kubectl patch`, `helm upgrade`, rollout restart, or
  pod deletion
- destructive data operations, DNS/firewall/billing changes, or public posting

Safe by default:

- reading advisories and release notes
- repo inspection
- metadata-only runtime checks
- local branch edits
- render/lint/schema/registry validation
- scoped commit of separable local changes

## Workflow Coordination

Use `vincent-workflow` for durable decisions, blockers, handoffs, commit/push
status, and cleanup.

Use `mira-review-gate` before accepting a merge, deploy, or shared-behavior change.
Use `codex-html-report` when the advisory decision needs a durable reader-facing proof report.
Use `codex-closeout` for final chat delivery.
