# Trigger Matrix

Use these prompts in fresh chats after a skill-pack change. The goal is to verify intended routing and catch overlap early.

Routing is nondeterministic: run each prompt 3 to 5 times and judge the distribution, not a single pass. A prompt that routes wrong even once in five runs usually means two descriptions overlap; fix the descriptions, not the prompt. See `docs/skill-authoring-best-practices.md` for the full authoring guidance.

## Frontend review overlay vs vendor frontend plugins

### 1. Frontend review

- Prompt: `review this settings page PR and tell me the highest-severity frontend issues before we merge`
- Expected: `frontend-anti-slop` (audit mode)
- Should not be first choice: `build-web-apps:frontend-app-builder`

### 2. Frontend redesign

- Prompt: `this dashboard works but looks like generic AI slop; redesign it so it feels more intentional`
- Expected: installed vendor plugin `build-web-apps:frontend-app-builder` for the redesign, with `frontend-anti-slop` only as an anti-slop review overlay
- Should not be first choice: `design-system-maintenance`

### 3. Responsive layout

- Prompt: `this page is fine on desktop but collapses badly on mobile and the filter bar wraps awkwardly`
- Expected: installed vendor plugin `build-web-apps:frontend-testing-debugging`
- Should not be first choice: `frontend-anti-slop`

### 4. Webapp testing

- Prompt: `I changed the signup flow; define the highest-value browser checks and verify the flow still works`
- Expected: installed vendor plugin `build-web-apps:frontend-testing-debugging`
- Should not be first choice: `playwright`, `frontend-anti-slop`

### 5. Browser driving only

- Prompt: `open this site in a real browser, click through the modal flow, and capture screenshots`
- Expected: `playwright`
- Should not be first choice: `build-web-apps:frontend-testing-debugging`

### 6. React performance

- Prompt: `this React table gets janky when filtering and typing; give me the biggest performance problems first`
- Expected: installed vendor plugin `build-web-apps:react-best-practices`
- Should not be first choice: `frontend-anti-slop`

### 7. Design system maintenance

- Prompt: `our shared button and form components have too many variants and teams keep bypassing tokens; how should we clean this up`
- Expected: `design-system-maintenance`
- Should not be first choice: `frontend-anti-slop`

## Web data visualization vs local report and UI overlays

### 7b. Analytical dashboard build

- Prompt: `build a web dashboard that compares revenue by segment over time, with chart choice, mobile behavior, and export checks`
- Expected: installed vendor plugin `build-web-data-visualization:data-visualization`
- Should not be first choice: `frontend-anti-slop`, `codex-html-report`

### 7c. Durable proof report

- Prompt: `create a browser-readable proof report for this migration with summary, verification, risks, evidence, and a small supporting chart`
- Expected: `codex-html-report`
- Should not be first choice: `build-web-data-visualization:data-visualization`

### 7d. Ownership graph analysis

- Prompt: `build a security ownership graph from git history and export CSV/JSON so we can inspect orphaned auth code`
- Expected: `security-ownership-map`
- Should not be first choice: `build-web-data-visualization:data-visualization`

### 7e. Ownership graph visualization

- Prompt: `turn this ownership graph export into an interactive node-link web visualization with layout, filtering, and visual regression checks`
- Expected: installed vendor plugin `build-web-data-visualization:data-visualization`
- Should not be first choice: `security-ownership-map`

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
- Should not be first choice: `jenkins-sre`, installed GitHub PR-comment routes

## Observability and reliability

### 13. Alerting incident

- Prompt: `Grafana is firing OOM alerts but the dashboards and cluster state do not agree`
- Expected: `prometheus-grafana-triage`
- Should not be first choice: `observability-architecture`

### 14. Observability architecture

- Prompt: `design the right metrics, traces, logs, retention, and alert-routing model for this platform`
- Expected: `observability-architecture`
- Should not be first choice: `prometheus-grafana-triage`

### 15. SLO design

- Prompt: `define meaningful SLIs, SLOs, and burn-rate alerts for our background job platform`
- Expected: no skill (retired 2026-07-03: bare model passes SLI/SLO design; Grafana SLO provisioning is `alerting-irm`)
- Should not be first choice: `observability-architecture`

### 16. Sentry issue inspection

- Prompt: `summarize the top recent production errors in Sentry for prod and tell me the likely clusters of failure`
- Expected: installed Sentry plugin
- Should not be first choice: `prometheus-grafana-triage`

## Planning and engineering workflow

### 17. Bug triage

- Prompt: `users say checkout is broken after yesterday's release; diagnose the likely root cause before changing code`
- Expected: `triage-issue`
- Should not be first choice: installed Superpowers `test-driven-development`

### 18. TDD

- Prompt: `implement this feature with a red-green-refactor loop and integration-style tests`
- Expected: installed Superpowers `test-driven-development`
- Should not be first choice: `triage-issue`

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

## Skill authoring

### 28. New skill with workflow state

- Prompt: `create a new skill for repo maintenance handoffs; it needs to record decisions, blockers, reports, and closeout proof`
- Expected: `skill-creator`
- Should not be first choice: adding generic workflow owners to every skill

### 29. Last 30 days research

- Prompt: `research the latest agent improvement techniques from the last 30 days across X, Reddit, YouTube, GitHub, and Hacker News`
- Expected: `last30days`
- Should not be first choice: a generic web summary without source collection

## Underused utility and review skills

### 30. Naming quality

- Prompt: `what should we call this new module and the API field it exposes so the name still makes sense after we move providers`
- Expected: `naming-quality`
- Should not be first choice: `design-an-interface`

### 31. Pressure-test a plan

- Prompt: `grill me on this architecture plan before I commit to it; what am I missing and what would bite us later`
- Expected: native agent reasoning grounded in the repository and current docs
- Should not be first choice: `request-refactor-plan`, `improve-codebase-architecture`

### 32. API or module interface design

- Prompt: `design this module interface two or three different ways and compare the trade-offs before we implement it`
- Expected: `design-an-interface`
- Should not be first choice: `request-refactor-plan`, `improve-codebase-architecture`

### 33. Codebase architecture opportunities

- Prompt: `explore this repo and find architectural refactors that would reduce coupling and make it easier for agents to work in`
- Expected: `improve-codebase-architecture`
- Should not be first choice: `request-refactor-plan`, `triage-issue`

### 34. Risky refactor plan

- Prompt: `this refactor is risky; turn it into tiny safe steps with a verification plan and clear out-of-scope boundaries`
- Expected: `request-refactor-plan`
- Should not be first choice: `improve-codebase-architecture`, installed Superpowers `test-driven-development`

### 35. Anti-AI writing pass

- Prompt: `make this draft less AI-sounding, more direct, and keep the technical meaning intact`
- Expected: `anti-ai-writing`
- Should not be first choice: ordinary drafting without an explicit prose pass

### 37. Implementation closeout

- Prompt: `summarize what changed, what passed, what failed, and whether the repo was committed and pushed`
- Expected: native agent closeout
- Should not be first choice: `codex-html-report`

### 38. Durable HTML report

- Prompt: `create a browser-readable proof report for this migration with summary, verification, risks, and evidence`
- Expected: `codex-html-report`

## Documents, media, and local surfaces

### 39. Word document work

- Prompt: `edit this docx template and verify the table layout and pagination still render correctly`
- Expected: installed OpenAI primary runtime Documents skill
- Should not be first choice: installed OpenAI primary runtime PDF skill

### 40. PDF layout work

- Prompt: `inspect this PDF visually, extract the important fields, and tell me whether the rendered layout is intact`
- Expected: installed OpenAI primary runtime PDF skill
- Should not be first choice: installed OpenAI primary runtime Documents skill, `screenshot`

### 41. Desktop screenshot

- Prompt: `take a screenshot of the current app window because the browser capture tool cannot see it`
- Expected: `screenshot`
- Should not be first choice: `playwright`

### 42. Audio transcription

- Prompt: `transcribe this meeting recording and label speakers where possible`
- Expected: `transcribe`
- Should not be first choice: installed OpenAI primary runtime Documents skill

### 43. Hatch Codex pet

- Prompt: `turn this character image into a Codex pet spritesheet and validate the animation frames`
- Expected: `hatch-pet`
- Should not be first choice: `imagegen`

## Security, ownership, and platform setup

### 44. Security best-practices review

- Prompt: `review this TypeScript API for security best practices and point out framework-specific risks`
- Expected: installed Codex Security plugin
- Should not be first choice: `triage-issue`

### 45. Security ownership map

- Prompt: `build a file ownership and bus-factor map from git history so we know who owns sensitive code`
- Expected: `security-ownership-map`
- Should not be first choice: installed Codex Security plugin

### 47. Azure infrastructure design

- Prompt: `design the Azure landing zone, networking, RBAC, and cost controls for this workload`
- Expected: installed Azure plugin skills
- Should not be first choice: `kubernetes-platform-architecture`

### 48. Grafana MCP setup

- Prompt: `connect Codex and Claude to Grafana Cloud through MCP and document the agent setup`
- Expected: `assistant-mcp`
- Should not be first choice: `prometheus-grafana-triage`

### 49. Microsoft 365 admin automation

- Prompt: `create a Microsoft 365 admin automation plan for Exchange Online users and Teams policy setup`
- Expected: `m365-admin`
- Should not be first choice: `l2-l3-support-platform`

### 50. L2/L3 support case

- Prompt: `investigate this customer support case and prepare an evidence-backed L2 to L3 escalation note`
- Expected: `l2-l3-support-platform`
- Should not be first choice: `log-analyzer`

## Tooling and migration

### 51. CLI creation

- Prompt: `build a CLI from these API docs and curl examples so agents can use the admin API safely`
- Expected: `cli-creator`
- Should not be first choice: `migrate-to-codex`

### 52. Migrate to Codex

- Prompt: `migrate these Claude skills, agents, and MCP config into Codex-compatible artifacts and validate the target`
- Expected: `migrate-to-codex`
- Should not be first choice: a manual migration without inspecting installed tools

### 53. Setup pre-commit

- Prompt: `add Husky and lint-staged so formatting and type checks run before commit`
- Expected: no skill (retired 2026-07-03: bare model passes Husky/lint-staged setup)
- Should not be first choice: `ci-pipeline-triage`

### 54. GitHub review comments

- Prompt: `fetch the unresolved review comments on this PR and apply the smallest fixes for each thread`
- Expected: installed GitHub plugin `gh-address-comments`
- Should not be first choice: `ci-pipeline-triage`

### 55. Systematic debugging

- Prompt: `this test failure makes no sense; trace the root cause before suggesting fixes`
- Expected: installed Superpowers `systematic-debugging`
- Should not be first choice: `triage-issue`, installed Superpowers `test-driven-development`

### 56. Alert routing and IRM

- Prompt: `configure Grafana alert contact points, notification policies, silences, and incident routing`
- Expected: `alerting-irm`
- Should not be first choice: `prometheus-grafana-triage`
