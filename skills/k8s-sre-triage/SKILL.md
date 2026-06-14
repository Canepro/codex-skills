---
name: k8s-sre-triage
description: Investigate Kubernetes and container runtime incidents with evidence-first triage. Use when pods are crashing or pending, rollouts are stuck, ingress or DNS routing is broken, storage or nodes are failing, or a GitOps-managed workload is unhealthy after deploy; prefer GitOps-safe remediation and verify recovery.
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

If the incident came from an alert or dashboard, identify the owning cluster before gathering pod evidence. Do not assume the current kube context is the one that produced the alert.

If the report is vague, ask one short clarifying question, then start gathering evidence.

### 2. Gather baseline state

Start with:
- `kubectl config current-context`
- `kubectl get nodes`
- `kubectl get pods -A`
- `kubectl get events -A --sort-by=.metadata.creationTimestamp`

Then narrow to the affected namespace and owner resource:
- `kubectl get deploy,statefulset,daemonset,job,cronjob -n <ns>`
- `kubectl describe pod <pod> -n <ns>`
- `kubectl logs <pod> -n <ns> --all-containers`
- `kubectl logs <pod> -n <ns> --all-containers --previous` when restarts are involved

Bundled helpers:
- `scripts/k8s_snapshot.sh` for a fast cluster-wide baseline snapshot
- `scripts/pod_triage.sh <namespace> <pod>` for pod-specific evidence

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

Before any destructive, live infra mutation, immediately confirm the target context and namespace, preserve pre-fix evidence before restarting, deleting, or replacing failing pods, and require explicit approval before `kubectl delete`, `kubectl patch`, `kubectl scale`, and `kubectl rollout restart`. Pause before final submission until consent is confirmed, then execute with a rollback plan and blast-radius notes.

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
- When checking previous logs for a restart, verify the pod namespace first. A correct command in the wrong namespace is still bad evidence.
- Treat Secret values, service-account tokens, private keys, kubeconfig contents, and any other credential material as redacted. Quote Secret names and keys as evidence, never decoded values. Do not paste token values or private key fragments into findings or handoffs.

## Related specialist skills

- Use `prometheus-grafana-triage` when the incident starts from an alert, scrape failure, dashboard mismatch, or Prometheus/Grafana signal.
- Use `promql` when Kubernetes health needs custom PromQL, ratios, histogram queries, or recording-rule checks.
- Use `loki` when the next step is LogQL, log parsers, Loki pipeline behavior, or log-derived metrics.
- Use `gitops-reconcile` when the runtime issue is caused by Argo CD or Flux convergence rather than cluster mechanics.
- Use `observability-architecture` when the result is a monitoring design gap, not a live runtime fix.
- Use `adversary-informed-defense` when the evidence suggests compromise rather than a fault: unexpected workloads, privilege changes, or credential misuse.

## References

- Read `references/failure-modes.md` when narrowing a Kubernetes runtime issue.

## Scripts

### `scripts/k8s_snapshot.sh`

Collects a deterministic snapshot of:
- current context
- nodes
- pods
- recent events
- services, ingress, PVCs, jobs, and cronjobs

Usage:
```bash
bash "${CODEX_HOME:-$HOME/.codex}/skills/k8s-sre-triage/scripts/k8s_snapshot.sh"
```

### `scripts/pod_triage.sh`

Collects pod-specific evidence:
- owner references
- `describe`
- current logs
- previous logs

Usage:
```bash
bash "${CODEX_HOME:-$HOME/.codex}/skills/k8s-sre-triage/scripts/pod_triage.sh" <namespace> <pod>
```

## Workflow Coordination

This skill owns its domain work. Use `vincent-workflow` for durable decisions, blockers, resume handoffs, known issues, commit/push/cleanup obligations, or project-local follow-up state. Use `codex-closeout` for final chat delivery, `codex-html-report` for durable reader-facing proof, and `second-brain-context` only for cross-repo or future local-brain retrieval.
