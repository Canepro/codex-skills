---
name: gitops-workflow
description: Design or improve a GitOps operating model for Kubernetes delivery, including repo layout, environment promotion, app boundaries, sync ordering, secrets handling, and rollback strategy. Use when the user wants to set up GitOps, review an existing GitOps workflow, or define how changes should move safely from Git to clusters over time.
metadata:
  short-description: Design a GitOps operating model
---

# GitOps Workflow

Use this skill for delivery-model design and repo/process decisions around GitOps.

## Use when

- designing a new GitOps setup
- reviewing repo structure for Argo CD or Flux
- deciding app boundaries, sync waves, or promotion flow
- choosing how environments and secrets should be managed
- reducing drift between teams, repos, and clusters

## Do not use when

- the main problem is a live convergence failure. Use `gitops-reconcile`.
- the main problem is broader Kubernetes platform design. Use `kubernetes-platform-architecture`.
- the request is a CI failure before manifests reach the controller. Use `ci-pipeline-triage`.

## Workflow

### 1. Map the current delivery path

Identify:
- source repos
- environment structure
- GitOps controller
- how revisions are promoted
- how secrets and cluster-specific values are injected
- where drift or manual steps currently enter

### 2. Define the desired operating model

Decide:
- mono-repo vs multi-repo responsibilities
- app-of-apps or other composition strategy
- environment promotion pattern
- policy for live changes and drift correction
- how ordering and dependencies are expressed

### 3. Make boundaries explicit

Clarify:
- what belongs in a platform repo vs service repo
- what one application object should own
- how shared infra is separated from app delivery
- how teams consume common components safely

### 4. Design for recoverability

Cover:
- rollback model
- bad manifest isolation
- stale or pinned revision handling
- bootstrap and disaster-recovery path

### 5. Produce a decision-quality recommendation

A good answer includes:
- recommended repo and controller shape
- promotion and rollback flow
- secrets strategy
- ordering strategy
- operational trade-offs and migration path

## Guidance

- Prefer fewer, clearer repos and application boundaries over clever layering.
- Keep the promotion model obvious to humans.
- Treat secrets, shared infrastructure, and ordering as first-class design problems.
- Do not make live patching part of the normal workflow.

## References

- Read `references/patterns.md` for working GitOps workflow patterns and trade-offs.
