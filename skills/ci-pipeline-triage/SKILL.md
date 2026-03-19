---
name: ci-pipeline-triage
description: Use when the user asks to investigate or fix failing CI/CD jobs, Jenkins builds, PR checks, Terraform validation runs, deployment pipelines, or stale pipeline diagnoses; identify the exact failing run and commit, extract the real failing line, and fix the problem in the correct layer.
metadata:
  short-description: Triage CI, Jenkins, and deployment pipeline failures
---

# CI Pipeline Triage

Treat pipeline incidents as evidence problems first. Identify the exact failing run, the exact failing stage, and the exact failing command before proposing a fix.

## Use when

- Jenkins jobs or PR builds are failing
- GitHub checks are red or stuck
- Terraform validation or plan steps are failing in CI
- a deployment pipeline failed after merge
- auto-generated diagnoses or issues look wrong or incomplete
- the user says “CI failed again” or “pipeline is stuck”

## Do not use when

- The primary problem is already inside the running cluster. Use `k8s-sre-triage`.
- The main problem is alert logic, scrape health, or Grafana/Prometheus behavior. Use `prometheus-grafana-triage`.
- The user only wants a code review without an active failing run.

## Workflow

### 1. Capture the exact run

Always identify:
- CI system
- repo
- branch or PR
- run URL or build number
- failing stage
- commit SHA
- whether the run is for branch head or merge commit

Do not debug “the pipeline” in the abstract.

### 2. Extract the real error

Find:
- the exact command that failed
- the exact stderr or failing log lines
- the first real failure, not just the summary banner

Be skeptical of:
- bot-generated diagnoses
- issue comments without console evidence
- stale failures from older SHAs

### 3. Classify the failure

Choose the primary category:
- pipeline logic or job configuration
- credential, secret, or identity failure
- environment mismatch between local and CI
- test or lint failure
- Terraform or infra validation failure
- deployment/GitOps convergence failure
- flaky or external dependency failure

### 4. Fix the correct layer

Prefer the smallest correct fix:
- app code if behavior is wrong
- Jenkinsfile or workflow config if the pipeline is wrong
- secret or credential setup if auth is wrong
- Terraform or infra config if validation is correct and the system is wrong
- docs only if behavior is already correct and the documentation is stale

Do not patch around a symptom in the wrong layer.

### 5. Verify

Use a local equivalent when practical:
- test command
- lint command
- Terraform validate/plan
- targeted script or build step

Then confirm the next pipeline run is on the current head SHA.

### 6. Close the loop

Summarize:
- what failed
- root cause
- fix
- local verification
- whether the next rerun is expected to pass

## Guidance

- Distinguish “failing now” from “old red check still visible”.
- If the failure comes from an external provider, say so explicitly.
- If a live unblock was required, note the resulting drift and how it will be reconciled.
- For recurring failures, prefer a durable config fix over re-running blindly.

## References

- Read `references/failure-categories.md` when the failing layer is still unclear.

