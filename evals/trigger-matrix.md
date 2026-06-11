# Trigger Matrix

Use these prompts in fresh chats after a skill-pack change. The goal is to verify intended routing and catch overlap early.

Routing is nondeterministic: run each prompt 3 to 5 times and judge the distribution, not a single pass. A prompt that routes wrong even once in five runs usually means two descriptions overlap; fix the descriptions, not the prompt. See `docs/skill-authoring-best-practices.md` for the full authoring guidance.

## Frontend review vs redesign vs responsive vs testing

### 1. Frontend review

- Prompt: `review this settings page PR and tell me the highest-severity frontend issues before we merge`
- Expected: `frontend-anti-slop` (audit mode)
- Should not be first choice: `responsive-design`, `webapp-testing`, `react-performance-review`

### 2. Frontend redesign

- Prompt: `this dashboard works but looks like generic AI slop; redesign it so it feels more intentional`
- Expected: `frontend-anti-slop`
- Should not be first choice: `responsive-design`, `design-system-maintenance`

### 3. Responsive layout

- Prompt: `this page is fine on desktop but collapses badly on mobile and the filter bar wraps awkwardly`
- Expected: `responsive-design`
- Should not be first choice: `frontend-anti-slop`, `webapp-testing`

### 4. Webapp testing

- Prompt: `I changed the signup flow; define the highest-value browser checks and verify the flow still works`
- Expected: `webapp-testing`
- Should not be first choice: `playwright`, `frontend-anti-slop`

### 5. Browser driving only

- Prompt: `open this site in a real browser, click through the modal flow, and capture screenshots`
- Expected: `playwright`
- Should not be first choice: `webapp-testing`

### 6. React performance

- Prompt: `this React table gets janky when filtering and typing; give me the biggest performance problems first`
- Expected: `react-performance-review`
- Should not be first choice: `frontend-anti-slop`

### 7. Design system maintenance

- Prompt: `our shared button and form components have too many variants and teams keep bypassing tokens; how should we clean this up`
- Expected: `design-system-maintenance`
- Should not be first choice: `frontend-anti-slop`

## GitOps and Kubernetes

### 8. Live GitOps incident

- Prompt: `Argo CD says this app is OutOfSync and one CRD-dependent resource is blocking the whole sync`
- Expected: `gitops-reconcile`
- Should not be first choice: `gitops-workflow`, `kubernetes-platform-architecture`

### 9. GitOps operating model

- Prompt: `help me design the repo layout, promotion flow, and rollback strategy for Argo CD across dev, stage, and prod`
- Expected: `gitops-workflow`
- Should not be first choice: `gitops-reconcile`

### 10. Kubernetes runtime incident

- Prompt: `after deploy, the pods are CrashLoopBackOff and the ingress is serving 502s`
- Expected: `k8s-sre-triage`
- Should not be first choice: `kubernetes-platform-architecture`

### 11. Kubernetes platform design

- Prompt: `we need to decide single-cluster vs multi-cluster, tenancy boundaries, and how GitOps should fit the platform`
- Expected: `kubernetes-platform-architecture`
- Should not be first choice: `k8s-sre-triage`, `gitops-reconcile`

### 12. Jenkins runtime

- Prompt: `our Jenkins inbound agents keep disconnecting and jobs queue forever even though the pipeline code is unchanged`
- Expected: `jenkins-sre`
- Should not be first choice: `ci-pipeline-triage`

### 12b. GitHub Actions PR checks

- Prompt: `this PR has two red GitHub Actions checks; pull the logs and tell me what is actually failing`
- Expected: `ci-pipeline-triage`
- Should not be first choice: `jenkins-sre`, `gh-address-comments`

## Observability and reliability

### 13. Alerting incident

- Prompt: `Grafana is firing OOM alerts but the dashboards and cluster state do not agree`
- Expected: `prometheus-grafana-triage`
- Should not be first choice: `observability-architecture`, `slo-sli-design`

### 14. Observability architecture

- Prompt: `design the right metrics, traces, logs, retention, and alert-routing model for this platform`
- Expected: `observability-architecture`
- Should not be first choice: `prometheus-grafana-triage`

### 15. SLO design

- Prompt: `define meaningful SLIs, SLOs, and burn-rate alerts for our background job platform`
- Expected: `slo-sli-design`
- Should not be first choice: `observability-architecture`

### 16. Sentry issue inspection

- Prompt: `summarize the top recent production errors in Sentry for prod and tell me the likely clusters of failure`
- Expected: `sentry`
- Should not be first choice: `prometheus-grafana-triage`

## Planning and engineering workflow

### 17. Bug triage

- Prompt: `users say checkout is broken after yesterday's release; diagnose the likely root cause before changing code`
- Expected: `triage-issue`
- Should not be first choice: `tdd`

### 18. TDD

- Prompt: `implement this feature with a red-green-refactor loop and integration-style tests`
- Expected: `tdd`
- Should not be first choice: `triage-issue`

### 19. PRD writing

- Prompt: `turn this rough feature idea into a concise PRD with success criteria and scope`
- Expected: `write-a-prd`
- Should not be first choice: `prd-to-plan`, `prd-to-issues`

### 20. PRD to plan

- Prompt: `take this PRD and turn it into a phased implementation plan with tracer bullets`
- Expected: `prd-to-plan`
- Should not be first choice: `write-a-prd`, `prd-to-issues`

### 21. PRD to issues

- Prompt: `break this PRD into small, independently shippable issue drafts`
- Expected: `prd-to-issues`
- Should not be first choice: `prd-to-plan`

## Logs and labels

### 22. LogQL query writing

- Prompt: `write a LogQL query that counts error-level lines per service over the last hour`
- Expected: `loki`
- Should not be first choice: `log-analyzer`, `loki-label-analyzer`, `promql`

### 23. Ad-hoc log forensics

- Prompt: `here is a pasted stack trace and a chunk of nginx logs from the ticket; tell me what actually happened`
- Expected: `log-analyzer`
- Should not be first choice: `loki`, `triage-issue`

### 24. Loki label audit

- Prompt: `our Loki queries got slow and ingestion costs keep climbing; review our label setup`
- Expected: `loki-label-analyzer`
- Should not be first choice: `loki`, `prometheus-label-strategy`

### 25. PromQL query writing

- Prompt: `give me a PromQL expression for p99 latency per route from these histogram buckets`
- Expected: `promql`
- Should not be first choice: `prometheus-grafana-triage`, `prometheus-cardinality-troubleshooter`

### 26. Cardinality fire

- Prompt: `Prometheus is OOMing and our active series count doubled since yesterday; help now`
- Expected: `prometheus-cardinality-troubleshooter`
- Should not be first choice: `promql`, `prometheus-label-strategy`

### 27. Label strategy design

- Prompt: `we are instrumenting a new service; design metric labels that will not blow up cardinality later`
- Expected: `prometheus-label-strategy`
- Should not be first choice: `prometheus-cardinality-troubleshooter`, `promql`

## Discovery

### 28. Skill discovery

- Prompt: `is there a skill that can help me work with Excel files, and how do I install it`
- Expected: `find-skills`
- Should not be first choice: `migrate-to-codex`
