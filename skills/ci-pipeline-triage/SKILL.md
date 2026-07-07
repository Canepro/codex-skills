---
name: ci-pipeline-triage
description: "Investigate failing CI/CD pipelines: GitHub Actions PR checks, Jenkins job failures, Terraform validate or plan in CI, and deploy stages. Use when builds are red, checks are stuck, or an auto-generated diagnosis looks wrong; find the exact failing run, stage, and command before fixing. For Jenkins controller or agent runtime health, use jenkins-sre."
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
- the user says "CI failed again" or "pipeline is stuck"

## Do not use when

- The primary problem is already inside the running cluster. Use `k8s-sre-triage`.
- The main problem is alert logic, scrape health, or Grafana/Prometheus behavior. Use `prometheus-grafana-triage`.
- The user only wants a code review without an active failing run.
- The problem is Jenkins controller or agent runtime health (offline nodes, executors, credentials). Use `jenkins-sre`.

## Workflow

### 0. Consent and pause before final actions

Before any final fix, merge push, rerun, or destructive action, require explicit approval from the user.
Before rerun or cancellation, save logs and artifacts from the current run so evidence is preserved before expiration, replacement, or rerun.
Pause before final submission to confirm intent and blast radius.

### 1. Capture the exact run

Always identify:
- CI system
- repo
- branch or PR
- run URL or build number
- failing stage
- commit SHA
- whether the run is for branch head or merge commit

Do not debug "the pipeline" in the abstract.

### 2. Extract the real error

Find:
- the exact command that failed
- the exact stderr or failing log lines
- the first real failure, not just the summary banner

Be skeptical of:
- bot-generated diagnoses
- issue comments without console evidence
- stale failures from older SHAs

Do not implement any fix until the exact failing command and the first real
failing stderr are reproducibly captured. Reproduce the failure first;
a fix built on the summary banner fixes the wrong layer, so gather the
evidence before implementing a change.

### 3. Classify the failure

Choose the primary category:
- skipped, cancelled, neutral, and required check statuses that are not true failures
- pipeline logic or job configuration
- credential, secret, token, private key, or identity failure
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

## GitHub Actions PR checks

When the failing run is a GitHub Actions check on a PR, use `gh` to capture the evidence for steps 1 and 2:

1. Verify auth with `gh auth status` (repo and workflow scopes). If unauthenticated, ask the user to run gh auth login first. If the token has insufficient scopes, treat that as a hard stop: pause evidence collection and ask the user to run gh auth refresh with the missing scopes before continuing.
2. Resolve the PR: `gh pr view --json number,url` for the current branch, or use the number or URL the user gave.
3. Preferred: run the bundled script, which handles `gh` field drift and job-log fallbacks:
   - `python3 "<path-to-skill>/scripts/inspect_pr_checks.py" --repo "." --pr "<number-or-url>"`
   - Add `--json` for machine-friendly output. It exits non-zero while failures remain, so it also works in automation.
4. Manual fallback:
   - `gh pr checks <pr> --json name,state,bucket,link,startedAt,completedAt,workflow`
   - For each failing check, extract the run id from `detailsUrl` or `link`, then `gh run view <run_id> --log`.
   - If the run is still in progress, fetch job logs directly: `gh api "/repos/<owner>/<repo>/actions/jobs/<job_id>/logs"`.
5. If the details URL or link is not a GitHub Actions run, label the check as external and report only the URL. Do not drive Buildkite or other providers from here.
6. If the failing run is branch-triggered or push-triggered and no pull request exists, skip the PR resolution step and inspect the run directly by branch or merge commit: `gh run list --branch <branch>` then `gh run view <run_id> --log`. Do not force PR-only triage.

## Guidance

- Distinguish "failing now" from "old red check still visible".
- If the failure comes from an external provider, say so explicitly.
- If the cause is an upstream external service outage, there is usually no code or config fix on our side: name the provider that owns the outage, link its status evidence, and escalate through the provider's path instead of editing the pipeline.
- Never copy, print, or share raw token or private key values in logs, notes, or tickets. If a live unblock was required, note the resulting drift and how it will be reconciled.
- For recurring failures, prefer a durable config fix over re-running blindly.

## References

- Read `references/failure-categories.md` when the failing layer is still unclear.

## Workflow Coordination

This skill owns its domain work. Use `vincent-workflow` for durable decisions, blockers, resume handoffs, known issues, commit/push/cleanup obligations, or project-local follow-up state. Use `codex-closeout` for final chat delivery, `codex-html-report` for durable reader-facing proof, and `second-brain-context` only for cross-repo or future local-brain retrieval.
