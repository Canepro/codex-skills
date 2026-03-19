---
name: k8s-sre-triage
description: Use when the user asks to investigate or fix Kubernetes, container, rollout, ingress, storage, node, namespace, or GitOps-managed runtime issues; gather evidence first, classify the failure mode, prefer GitOps-safe remediation, and verify recovery before closing.
metadata:
  short-description: Triage Kubernetes and runtime incidents safely
---

# Kubernetes SRE Triage

Investigate Kubernetes and container incidents with a repeatable workflow. Start with read-only evidence collection, classify the failure mode, then choose the narrowest safe fix. Prefer Git-backed remediation when the workload is GitOps-managed.

## Use when

- Pods are `Pending`, `CrashLoopBackOff`, `Error`, or repeatedly restarting
- A rollout is stuck or a workload is unhealthy after deploy
- Ingress, service, DNS, TLS, or endpoint routing is broken
- PVCs, volumes, or storage mounts are failing
- Nodes are unhealthy or workloads are not scheduling
- Argo CD or another GitOps controller is blocked by runtime issues in-cluster

## Do not use when

- The problem is primarily a CI log or PR check failure before deployment. Use `ci-pipeline-triage`.
- The problem is primarily Prometheus, Alertmanager, scrape health, or Grafana alert logic. Use `prometheus-grafana-triage`.
- The user wants cluster provisioning, architecture design, or migration planning rather than incident response.

## Workflow

### 1. Establish scope

Capture:
- current kube context
- affected cluster, namespace, workload, or URL
- user-visible impact
- whether the workload is GitOps-managed

If the report is vague, ask one short clarifying question, then start gathering evidence.

### 2. Gather baseline state

Start with:
- `kubectl config current-context`
- `kubectl get nodes`
- `kubectl get pods -A`
- `kubectl get events -A --sort-by=.lastTimestamp`

Then narrow to the affected namespace and owner resource:
- `kubectl get deploy,statefulset,daemonset,job,cronjob -n <ns>`
- `kubectl describe pod <pod> -n <ns>`
- `kubectl logs <pod> -n <ns> --all-containers`
- `kubectl logs <pod> -n <ns> --all-containers --previous` when restarts are involved

### 3. Classify the failure

Put the problem into one primary bucket before changing anything:
- scheduling: unschedulable, taints, quotas, missing PVC, node pressure
- runtime: crash loop, bad config, secret/env mismatch, probe failure
- networking: service selector mismatch, endpoints missing, ingress/TLS/DNS error
- storage: PVC pending, mount failures, permissions, volume exhaustion
- GitOps: desired state invalid, sync blocked, CRD/operator dependency missing
- provider dependency: identity, load balancer, cloud API, stopped cluster

Use the reference file for the likely bucket instead of branching into every theory at once.

### 4. Prefer GitOps-safe fixes

If the resource is GitOps-managed:
- inspect the manifest or Helm values in Git before making changes
- use live patches only when necessary to restore service quickly
- if a live fix is made, record the drift and reconcile it back into Git

Do not leave the system in an undocumented drift state.

### 5. Verify recovery

After any fix:
- confirm pods are healthy and ready
- confirm services/endpoints/ingress resolve correctly
- confirm rollout has converged
- confirm the original symptom is gone
- if monitoring exists, confirm alerts or scrape failures have cleared

### 6. Summarize clearly

Report:
- symptom
- root cause
- fix applied or recommended
- verification evidence
- residual risk or follow-up work

## Guidance

- Separate symptom, root cause, and remediation. Do not blur them.
- Prefer a single evidence-backed diagnosis over several weak guesses.
- If you cannot prove root cause yet, say what is still unknown and what evidence would resolve it.
- Do not assume provider-specific behavior; verify it.

## References

- Read `references/failure-modes.md` when narrowing a Kubernetes runtime issue.

