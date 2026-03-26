---
name: kubernetes-platform-architecture
description: Design Kubernetes platform architecture for production workloads, including cluster topology, tenancy, networking, delivery strategy, security boundaries, upgrades, and operational ownership. Use when planning a Kubernetes platform, multi-cluster model, namespace strategy, GitOps operating model, or long-term platform direction rather than debugging a live incident.
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

## Do not use when

- the main problem is a live cluster incident. Use `k8s-sre-triage`.
- the main problem is GitOps convergence on a specific app. Use `gitops-reconcile`.
- the request is only about alert noise or scrape failures. Use `prometheus-grafana-triage`.

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

- Read `references/platform-decisions.md` for the decision matrix.
