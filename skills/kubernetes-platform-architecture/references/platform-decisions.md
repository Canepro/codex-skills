# Kubernetes Platform Decision Matrix

## Topology

Choose **single cluster** when:
- the team is small
- environments can share control plane risk
- compliance boundaries are modest
- operational overhead must stay low

Choose **multiple clusters** when:
- blast radius must be isolated
- environments require stronger separation
- teams or business units need clearer boundaries
- region or compliance constraints force separation

## Tenancy

- **Namespace tenancy** is usually enough for cooperating teams.
- **Cluster tenancy** is justified when trust, compliance, or noisy-neighbor risk is materially different.

## Delivery model

- Prefer **GitOps** when auditable, convergent deployment flow matters.
- Prefer progressive delivery only when the team can operate it well.
- Keep rollout mechanics consistent across services where possible.

## Security and policy

Decide explicitly:
- secret source of truth
- admission policy engine
- image provenance requirements
- RBAC ownership boundaries
- network segmentation expectations

## Upgrade strategy

- decide supported Kubernetes version skew
- define maintenance window or continuous upgrade pattern
- test cluster-addons against upgrades before production

## Anti-patterns

- adding service mesh without a demonstrated need
- mixing incompatible ownership models in one cluster
- letting namespace conventions substitute for real policy
- adopting too many platform primitives at once
