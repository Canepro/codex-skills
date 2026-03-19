# Kubernetes Failure Modes

Use this file only after you know the incident is primarily a Kubernetes runtime problem.

## Scheduling

Check:
- `kubectl describe pod <pod>` for scheduling events
- node taints and tolerations
- resource requests vs node allocatable
- missing PVCs or unbound claims
- namespace quotas and limit ranges

Typical causes:
- PVC not bound
- requests exceed available CPU/memory
- node selectors or affinity rules exclude all nodes
- taints without tolerations

## Crash loops and restarts

Check:
- current logs
- previous logs
- probe failures in `describe`
- recent config/secret/image changes

Typical causes:
- missing env vars or secret keys
- wrong command/args
- bad migration or startup dependency
- liveness probe too aggressive

## Networking and ingress

Check:
- service selector and matching pods
- endpoints / endpoint slices
- ingress backend service and port names
- target path and health endpoints
- TLS secret and hostname alignment

Typical causes:
- service selector mismatch
- wrong named port
- ingress points at wrong backend
- TLS certificate or DNS mismatch

## Storage

Check:
- PVC phase
- storage class
- mount errors in pod events
- filesystem full metrics if available

Typical causes:
- unbound PVC
- wrong access mode
- missing storage class
- mount permission problem

## GitOps blockers

Check:
- controller health and sync state
- invalid CRDs or unavailable APIs
- namespace dependencies
- operator readiness before CRs

Typical causes:
- one invalid manifest blocking a larger sync
- missing CRD/operator
- app ordering problem
- manual live changes causing drift

## Provider-side issues

Check:
- managed identity or IAM/RBAC errors
- load balancer provisioning
- cluster stopped or nodes unavailable
- control plane reachable but workers missing

Typical causes:
- workload identity misconfiguration
- cloud permission missing
- node pool not ready
- external IP or LB reconciliation delay

