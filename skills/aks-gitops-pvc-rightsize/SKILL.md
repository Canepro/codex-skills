---
name: aks-gitops-pvc-rightsize
description: "Reduce or change an Azure AKS PVC disk size or storage class in a GitOps-managed workload, including when ArgoCD or Flux runs outside the cluster. Covers backup, PVC recreation, restore, verification, and cost cleanup. Not for GitOps sync failures (gitops-reconcile) or live pod incidents (k8s-sre-triage)."
metadata:
  short-description: Safely right-size AKS GitOps PVC disks
---

# AKS GitOps PVC Right-Size

Use this for AKS persistent volume cost cleanup when a workload is GitOps-managed and the fix requires changing PVC size or storage class.

## Core Rules

- Treat PVC shrink/storage-class changes as **backup/recreate/restore**, not in-place mutation.
- Respect ownership:
  - Terraform/Bicep owns Azure infrastructure.
  - ArgoCD/Flux owns Kubernetes desired state.
  - AKS dynamic provisioning owns Kubernetes-created Azure disks.
- Do not delete Azure managed disks directly from the AKS managed resource group unless the user explicitly asks for emergency cleanup after Kubernetes ownership is removed.
- Do not proceed without a fresh backup outside the PVC being replaced.
- If the GitOps controller is outside AKS, verify it can still reach the target cluster after AKS starts.
- If the GitOps controller keeps healing application writers during maintenance, temporarily pause automated sync for the writer-owning app, then restore the original policy immediately after restore.
- Stop AKS again after discovery or maintenance when the user's cost posture is manual-start/pay-per-use.

## Workflow

1. **Read-only discovery**
   - Check AKS power/provisioning state.
   - Check nodes, pods, PVCs, PVs, storage classes, and GitOps app status.
   - Map Azure disks to PVCs using disk tags.
   - Measure actual filesystem and application data size.

2. **Choose the target**
   - Pick a Standard SSD-backed class for low-use test workloads when appropriate.
   - Keep restore and growth headroom. Prefer a conservative first reduction over a minimum-fit disk.
   - Record the current PVC size/class, target size/class, and evidence.

3. **Backup gate**
   - Create a fresh application-native backup, such as `mongodump --archive --gzip` for MongoDB.
   - Copy it outside Git-tracked paths and outside the PVC being replaced.
   - Verify the backup file exists and is non-empty.

4. **Stop writes**
   - Scale application writers down through the safest available route.
   - Keep the database available until the backup is complete.
   - For ArgoCD, confirm whether a separate Helm/app controller will self-heal replicas. If needed, patch only that app's automated sync off for the short restore window and record the original policy.

5. **GitOps change**
   - Edit the desired-state manifest in Git.
   - Commit and push through the repo's normal deployment path.
   - Sync or wait for the external GitOps controller to see the new desired state.

6. **Recreate storage**
   - Delete/recreate the Kubernetes workload/PVC only after the backup and GitOps change are in place.
   - Let the operator/controller recreate the volume from GitOps desired state.
   - Confirm the new PVC has the intended size and storage class.

7. **Restore and verify**
   - Restore with application-native tooling.
   - Verify database health, workload readiness, service endpoints, ingress/API response, and GitOps convergence.
   - Check Azure disk inventory to confirm the old oversized disk is gone and the replacement exists.
   - Restore the GitOps app's automated sync policy if it was paused.

8. **Closeout**
   - Stop AKS again if this is a pay-per-use/test cluster.
   - Update a runbook or HTML report with evidence, commands, risks, and next action.

## Stop Conditions

- No fresh backup.
- GitOps controller cannot reach the target cluster.
- Target storage class does not exist.
- Application data size is too close to the proposed target.
- Restore tooling is absent or untested.
- The user has not accepted downtime for a stateful workload.

## Verification Proof

Capture:

- `kubectl get pod,pvc,pv`
- Storage class details.
- Backup file path and size, without secrets.
- Restore command result.
- Application health endpoint or equivalent.
- GitOps app sync/health state.
- Any temporary GitOps sync pause and proof it was restored.
- AKS stopped status after the window, when applicable.

## Live AKS Notes

- AKS API DNS can be flaky immediately after start on local machines. If `kubectl` fails to resolve the AKS API FQDN but `dig` works, use a temporary `--server=https://<resolved-ip>:443 --tls-server-name=<aks-fqdn>` override for the maintenance commands.
- For operator-managed MongoDB workloads, prefer restoring only application namespaces so operator-managed admin/user internals are not overwritten.

## Workflow Coordination

This skill owns the AKS PVC right-size runbook and stateful-workload safety gates. Use `vincent-workflow` for durable blockers, decisions, handoffs, known issues, and commit/push/cleanup state. Use the relevant workload-specific runtime triage skill when the target system needs incident diagnosis rather than planned PVC maintenance. Use `gitops-reconcile` when the change must converge through GitOps source of truth and the sync misbehaves. Use `codex-html-report` for reader-facing maintenance proof and `codex-closeout` for final chat delivery.
