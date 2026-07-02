# GitOps Reconcile Patterns

Use this file when the user’s manifests and the controller disagree about what should be live.

## Stale revision or failed operation

Symptoms:
- app still points at an older bad SHA
- merged fix exists in Git but controller has not attempted it
- operation shows `Failed` and no new sync occurs

Safe action:
- terminate the stale operation
- refresh and sync against the current revision

## Invalid bundle member

Symptoms:
- one resource kind is unsupported on the cluster
- a dead manifest blocks namespaces or unrelated resources in the same app

Safe action:
- remove or conditionally exclude the invalid manifest in Git
- avoid leaving a dead resource in the app definition

## Ordering problem

Symptoms:
- namespaced resources fail because namespace is missing
- CRs fail because operator or CRD is not ready
- external secrets expected before consuming apps

Safe action:
- add explicit ordering in Git
- prefer sync waves or app-of-apps dependency structure

## Cluster-specific capability mismatch

Symptoms:
- one cluster supports cert-manager or another CRD but another does not
- shared manifests assume platform features that are absent

Safe action:
- keep the cluster-specific manifest set accurate
- do not force unsupported resources into a cluster

## Flux command equivalents

The bundled `argocd_health.sh` script is Argo CD only. For Flux, use:

- status snapshot: `flux get kustomizations` (add `flux get helmreleases` and `flux get sources git` as needed)
- force a reconcile including the source: `flux reconcile kustomization <name> --with-source`
- pause reconciliation before a manual intervention: `flux suspend kustomization <name>`
- resume it afterward: `flux resume kustomization <name>`

## Drift after emergency action

Symptoms:
- live fix restored service
- Git still says something different

Safe action:
- reconcile the live fix back into Git or revert the live override promptly
- note the drift explicitly until it is closed

