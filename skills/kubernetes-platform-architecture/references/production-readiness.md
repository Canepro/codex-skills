# Production Readiness Reference

Working defaults for workload and cluster decisions. Treat them as starting points, not policy; the platform constraints gathered in the main workflow override them.

## Deployment strategy selection

```
+-- Zero downtime required?
|   +-- Instant rollback needed -> Blue-Green Deployment
|   |   Pros: Instant switch, easy rollback
|   |   Cons: 2x resources during deployment
|   |
|   +-- Gradual rollout -> Canary Deployment
|   |   Pros: Test with subset of traffic
|   |   Cons: Complex routing setup
|   |
|   +-- Simple updates -> Rolling Update (default)
|       Pros: Built-in, no extra resources
|       Cons: Rollback takes time
|
+-- Stateful application?
|   +-- Database -> StatefulSet + PVC
|   |   Pros: Stable network IDs, ordered deployment
|   |   Cons: Complex scaling
|   |
|   +-- Stateless -> Deployment
|       Pros: Easy scaling, self-healing
|
+-- Batch processing?
    +-- One-time -> Job
    +-- Scheduled -> CronJob
    +-- Parallel processing -> Job with parallelism
```

## Resource configuration starting points

| Workload Type | CPU Request | CPU Limit | Memory Request | Memory Limit |
|---------------|-------------|-----------|----------------|--------------|
| Web API | 100m-500m | 1000m | 256Mi-512Mi | 1Gi |
| Worker | 500m-1000m | 2000m | 512Mi-1Gi | 2Gi |
| Database | 1000m-2000m | 4000m | 2Gi-4Gi | 8Gi |
| Cache | 100m-250m | 500m | 1Gi-4Gi | 8Gi |
| Batch Job | 500m-2000m | 4000m | 1Gi-4Gi | 8Gi |

## Node pool strategy

| Use Case | Instance Type | Scaling | Cost |
|----------|--------------|---------|------|
| System pods | t3.large (3 nodes) | Fixed | Low |
| Applications | m5.xlarge | Auto 3-20 | Medium |
| Batch/Spot | m5.large-2xlarge | Auto 0-50 | Very Low |
| GPU workloads | p3.2xlarge | Manual | High |

Instance names are AWS examples; map to the equivalent tier on AKS or GKE.

## Red flags: stop and escalate

- Cluster upgrade with breaking API changes (deprecated versions)
- Multi-region active-active requirements
- Compliance requirements (PCI-DSS, HIPAA) that need validation
- Custom scheduler or controller development
- etcd corruption or cluster state issues

## Production quality checklist

### Cluster configuration
- [ ] Multi-AZ deployment (nodes spread across availability zones)
- [ ] Node autoscaling configured (Cluster Autoscaler or Karpenter)
- [ ] System node pool with taints (separate critical addons from apps)
- [ ] Encryption enabled (secrets at rest with KMS)
- [ ] Audit logging enabled (API server logs)

### Security
- [ ] Pod Security Standards enforced (restricted or baseline)
- [ ] Network policies configured (default deny + explicit allow)
- [ ] RBAC configured (least privilege for all service accounts)
- [ ] Image scanning enabled
- [ ] Private container registry configured

### Resource management
- [ ] All pods have resource requests and limits
- [ ] HorizontalPodAutoscalers configured for scalable workloads
- [ ] PodDisruptionBudgets defined
- [ ] ResourceQuotas set per namespace
- [ ] LimitRanges defined (default limits for pods)

### High availability
- [ ] Deployments have at least 2 replicas
- [ ] Anti-affinity rules prevent pod co-location
- [ ] Readiness and liveness probes configured
- [ ] PodDisruptionBudgets allow rolling updates
- [ ] Multi-region cluster only if global scale requires it

### Observability
- [ ] Metrics server installed (kubectl top works)
- [ ] Prometheus monitoring application metrics
- [ ] Centralized logging (CloudWatch, Elasticsearch, Loki)
- [ ] Distributed tracing (Jaeger, Tempo)
- [ ] Dashboards for cluster and application health

### Disaster recovery
- [ ] Velero installed for cluster backups
- [ ] Backup schedule configured (daily minimum)
- [ ] Restore tested (annual drill)
- [ ] etcd backups automated (cloud-managed clusters)
