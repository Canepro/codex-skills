---
name: jenkins-sre
description: Use when the user asks to investigate or fix Jenkins controller, agent, credential, queue, executor, or WebSocket/inbound-agent issues; verify the exact controller and node state, distinguish Jenkins runtime problems from pipeline code failures, and prefer durable config fixes over one-off restarts.
metadata:
  short-description: Diagnose Jenkins controller and agent runtime issues
---

# Jenkins SRE

Use this skill for Jenkins runtime and control-plane issues, not for generic build logic failures. Start by identifying whether the problem is controller health, agent connectivity, credentials, or queue/executor behavior.

## Use when

- Jenkins agents are offline, flapping, or rejected
- inbound/WebSocket agents fail handshake or reconnect
- credentials or secrets appear wrong at runtime
- jobs are queued but never scheduled
- the controller is unhealthy, overloaded, or plugin/runtime behavior is suspect
- the user asks about Jenkins nodes, executors, secrets, or controller state

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
- executor availability
- queue backlog
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
- queued jobs can schedule

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

## References

- Read `references/runtime-patterns.md` when narrowing a Jenkins operational issue.

