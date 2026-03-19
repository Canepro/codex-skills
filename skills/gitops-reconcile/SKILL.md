---
name: gitops-reconcile
description: Use when the user asks to investigate or fix Argo CD, Flux, or GitOps convergence problems such as OutOfSync apps, unhealthy resources, blocked syncs, stale revisions, missing CRDs, namespace ordering, or desired-vs-live drift; inspect desired state first, identify the specific blocker, and restore convergence safely.
metadata:
  short-description: Diagnose and restore GitOps convergence
---

# GitOps Reconcile

Treat GitOps incidents as convergence failures, not generic cluster failures. Start by identifying the controller, the desired revision, and the specific resource that is blocking reconciliation.

## Use when

- Argo CD or Flux shows `OutOfSync`, `Missing`, `Progressing`, or `Degraded`
- a merged repo change is not landing in-cluster
- an app is pinned to an old or failed revision
- one invalid resource is blocking a larger bundle
- namespace, CRD, or operator ordering is preventing sync
- the user asks why live state does not match Git

## Do not use when

- The main problem is a CI build or PR check failure before deployment. Use `ci-pipeline-triage`.
- The main problem is a runtime app failure after the correct manifests have already landed. Use `k8s-sre-triage`.
- The main problem is alert logic or scrape behavior. Use `prometheus-grafana-triage`.

## Workflow

### 1. Establish the desired state

Identify:
- controller: Argo CD, Flux, or another reconciler
- app or application set name
- target repo, path, branch, and revision
- whether the problem is current head, stale pinned revision, or live drift

Do not start by patching live resources.

### 2. Inspect controller state

Capture:
- sync status
- health status
- operation state
- revision the controller believes it should apply
- specific resources marked `Missing`, `OutOfSync`, `Degraded`, or invalid

Look for:
- stale failed operation still pinned
- invalid bundle member blocking the rest
- dependency/order issue
- missing CRD/operator/namespace

### 3. Identify the real blocker

Find the narrowest blocking resource or dependency. Common patterns:
- invalid CR kind because CRD is absent
- namespace missing before namespaced resources
- operator not ready before custom resources
- wrong app ordering or sync wave
- one dead manifest blocking unrelated resources in the same app

### 4. Choose the safe fix path

Prefer:
- fix manifests in Git
- adjust ordering or sync waves in Git
- remove dead resources from the Git bundle if the target cluster does not support them

Live controller actions are acceptable when needed to unblock current convergence:
- terminate stale failed operation
- refresh or resync against the correct revision

If you make a live controller action, say so explicitly. If you make a live manifest patch, reconcile it back into Git immediately.

### 5. Verify convergence

After the fix:
- app revision matches expected Git revision
- sync is clean
- health is healthy
- previously missing resources exist
- downstream apps no longer block on prerequisites

### 6. Summarize

Report:
- desired state
- actual blocking condition
- fix applied or recommended
- whether any temporary live action was taken
- whether any drift remains to reconcile

## Guidance

- Separate “repo is wrong” from “controller is stuck”.
- Treat stale failed operations as controller state, not manifest truth.
- If one invalid resource is cluster-specific, prefer removing or conditionally excluding it in Git instead of forcing it live.

## References

- Read `references/reconcile-patterns.md` when narrowing a GitOps sync failure.

