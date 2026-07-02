---
name: kubernetes-platform-architecture
description: "Design Kubernetes platform architecture: cluster topology, tenancy, namespace strategy, networking, security boundaries, upgrades, and operational ownership on EKS, AKS, GKE, or on-prem. Use for platform planning, multi-cluster models, Helm or operator adoption, and cost or upgrade direction. Not for live incidents (k8s-sre-triage) or GitOps delivery-model design (gitops-workflow)."
metadata:
  short-description: Design Kubernetes platform architecture
---

# Kubernetes Platform Architecture

Use this skill for platform design and durable operating-model decisions.

## Use when

- planning a new Kubernetes platform
- choosing single-cluster vs multi-cluster topology
- defining namespace, tenancy, and environment boundaries
- deciding how GitOps, secrets, policy, and upgrades should work
- reviewing an existing cluster platform for architectural weaknesses
- planning Kubernetes upgrades, deployment strategy (rolling, blue-green, canary), or resource and cost optimization
- designing Helm chart, operator, or service mesh adoption for the platform

## Do not use when

- the main problem is a live cluster incident. Use `k8s-sre-triage`.
- the main problem is GitOps convergence on a specific app. Use `gitops-reconcile`.
- the request is only about alert noise or scrape failures. Use `prometheus-grafana-triage`.
- the request is about the GitOps operating model: repo layout, promotion flow, secrets handling, rollback. Use `gitops-workflow`.

## Workflow

### 1. Gather platform constraints

Clarify:
- workload types and criticality
- team structure and ownership model
- compliance or isolation requirements
- availability targets
- expected scale and growth
- cloud or on-prem constraints

### 2. Choose topology deliberately

Decide:
- single cluster vs multiple clusters
- environment split strategy
- regional placement
- workload isolation boundaries

The right answer depends on blast radius, ownership clarity, and compliance, not fashion.

### 3. Define core platform boundaries

Specify:
- namespace and tenancy model
- networking model and ingress approach
- secret management pattern
- policy enforcement and admission controls
- identity and RBAC model
- storage classes and stateful workload guidance

### 4. Define delivery and operations

Cover:
- GitOps structure
- rollout strategy
- upgrade cadence
- backup and disaster recovery expectations
- observability ownership
- capacity and cost review loops

### 5. Produce decision-quality output

A good answer includes:
- recommended architecture
- why alternatives were rejected
- operational consequences
- migration path from current state
- major risks and unknowns

## Guidance

- Prefer the simplest architecture that preserves clear ownership and safe blast radius.
- Avoid multi-cluster by reflex.
- Avoid single-cluster by reflex.
- Treat tenancy, secrets, and upgrade strategy as first-class decisions, not follow-up tasks.

## References

- Read `references/platform-decisions.md` when choosing between topology, tenancy, or delivery options; it holds the decision matrix.
- Read `references/production-readiness.md` when deciding deployment strategy, resource and node-pool starting points, or reviewing a platform for production readiness.
- Read `references/kubernetes-reference.md` when a recommendation needs exact Kubernetes API or feature details.
- Read `references/kubernetes-examples.md` when the output should include concrete manifests or code examples.

## Workflow Coordination

This skill owns its domain work. Use `vincent-workflow` for durable decisions, blockers, resume handoffs, known issues, commit/push/cleanup obligations, or project-local follow-up state. Use `codex-closeout` for final chat delivery, `codex-html-report` for durable reader-facing proof, and `second-brain-context` only for cross-repo or future local-brain retrieval.
