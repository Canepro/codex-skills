---
name: jenkins-sre
description: Investigate Jenkins controller and agent runtime problems such as offline nodes, queue or executor issues, credential failures, WebSocket or inbound-agent errors, and controller health problems. Use when Jenkins itself looks unhealthy or misconfigured; distinguish runtime problems from pipeline code failures and prefer durable fixes.
metadata:
  short-description: Diagnose Jenkins controller and agent runtime issues
---

# Jenkins SRE

Use this skill for Jenkins runtime and control-plane issues, not for generic build logic failures. Start by identifying whether the problem is controller health, agent connectivity, credentials, or queue/executor behavior.

## Use when

- Jenkins agents are offline, flapping, or rejected
- inbound/WebSocket agents fail handshake or reconnect
- credentials or secrets appear wrong at runtime
- jobs are queued but never scheduled, including cases where label expression, node labels, or executor mismatch block assignment
- the controller is unhealthy, overloaded, or plugin/runtime behavior is suspect
- the user asks about Jenkins nodes, executors, agent secrets, or controller state

## Do not use when

- The main problem is the content of a failing build step. Use `ci-pipeline-triage`.
- The main problem is already in the deployed application or Kubernetes runtime. Use `k8s-sre-triage`.
- The user only wants to update Jenkins documentation with no live operational issue.

## Workflow

### 1. Identify the exact Jenkins surface

Capture:
- controller URL
- job or agent name
- whether the issue is controller-wide or node-specific
- launch mode: inbound, WebSocket, static agent, Kubernetes plugin, etc.

### 2. Check controller state

Look at:
- controller health and recent logs
- executor availability and executor mismatch
- queue backlog with waiting item label expression and target node labels
- node list and connection status

Separate:
- controller healthy but agent broken
- agent connected but build failing
- credentials present but wrong value

### 3. For agent problems, verify the chain

Check:
- node exists on controller
- launch command/secret matches current node definition
- Kubernetes secret or runtime env matches the expected Jenkins secret
- transport mode matches the node definition
- for suspected regressions, collect jenkins core version, plugin versions, and recent upgrades to confirm whether controller or agent behavior changed

Common failure patterns:
- stale or regenerated node secret
- same node name reused with mismatched session state
- agent pod healthy but rejected by controller
- wrong cluster or namespace receiving the secret

### 4. Fix at the right layer

Prefer:
- recreating or regenerating the node cleanly if Jenkins-side state is stale
- updating the backing secret in the runtime platform
- restarting the agent after the secret or node definition is correct

Avoid:
- repeatedly bouncing pods without verifying controller-side state
- treating handshake failures as Kubernetes failures by default

### 5. Verify

After the fix:
- Jenkins shows the node online
- agent pod stays healthy
- WebSocket or inbound connection remains established
- queued jobs can schedule on nodes where label expression and node labels match and executor mismatch is resolved

### 6. Summarize

Report:
- whether the issue was controller-side, node-side, or secret-side
- what was stale or mismatched
- what was changed
- what evidence shows the node is healthy now

## Guidance

- For inbound agents, the controller is the source of truth for node name and secret.
- When the controller rejects a healthy pod, suspect node/session/secret state before suspecting Kubernetes.
- Distinguish “job failed on agent” from “agent cannot connect”.
- For optional or scheduled agents, verify whether the agent is expected online before reporting it as failed. Cost-controlled agents may be intentionally parked.

## Related specialist skills

- Use `k8s-sre-triage` when the Jenkins controller or agent runs on Kubernetes and the evidence points to pods, services, storage, or ingress.
- Use `prometheus-grafana-triage` when Jenkins health is being inferred from Grafana, Prometheus, Loki, or alert state.
- Use `loki` for Jenkins log queries through Loki.
- Use `alerting-irm` when the fix is alert routing, silencing, or scheduled maintenance notification rather than Jenkins runtime repair.
- Use `codex-html-report` for durable proof artifacts when handing off incident outcomes and recovery evidence.

## References

- Read `references/runtime-patterns.md` when narrowing a Jenkins operational issue.

## Workflow Coordination

This skill owns its domain work. Use `vincent-workflow` for durable decisions, blockers, resume handoffs, known issues, commit/push/cleanup obligations, or project-local follow-up state. Use `codex-closeout` for final chat delivery, `codex-html-report` for durable reader-facing proof, and `second-brain-context` only for cross-repo or future local-brain retrieval.

For live infra work, require explicit approval and explicit consent gates before destructive actions. Pause before destructive changes such as node recreation, pod deletion, secret rotation, or controller plugin updates. In these flows:
- Handle token and private key material as secrets, keep outputs redacted, and do not echo token or private key values.
- Separate secret metadata review from secret-value handling, and use the user's secrets manager for approved token and credential paths.
- Keep authority boundaries explicit for agent, service, and operator handoffs; before changing controller state that affects production builds (node definitions, credentials, plugins), get explicit consent from the user first.
- Route evidence updates and proof to `codex-html-report` so recovery state stays durable and reviewable.
