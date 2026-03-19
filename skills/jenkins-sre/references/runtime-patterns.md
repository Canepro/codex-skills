# Jenkins Runtime Patterns

## Agent offline or flapping

Check:
- node exists on controller
- launch method is what the runtime expects
- node secret has not changed
- agent pod or VM can reach the controller

Common cause:
- stale node secret or stale controller-side node state

## WebSocket or inbound handshake failure

Check:
- exact node name
- current Jenkins launch command
- runtime secret value
- whether the node was recreated but the runtime still uses the old secret

Common cause:
- Jenkins-side node definition changed, runtime secret did not

## Queue stuck, no executors

Check:
- controller executors and queue
- labels on jobs vs labels on nodes
- offline nodes
- throttling or concurrency settings if relevant

Common cause:
- label mismatch or no online executor for the requested label

## Credential looks present but build still fails

Check:
- credential ID is correct
- secret value is current
- job or pipeline is reading the intended credential
- env var or secret injection did not override with empty string

Common cause:
- stale or blank credential, or wrong credential ID in pipeline config

## Controller healthy, build unhealthy

If:
- node is online
- job runs
- build step fails in script/test/plan

Then this is not a Jenkins SRE problem. Hand off to `ci-pipeline-triage`.

