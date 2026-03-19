# CI Failure Categories

Use this file when the failing run is real but the correct fix layer is not obvious.

## Pipeline logic

Signals:
- wrong checkout ref
- wrong branch/merge SHA
- bad script path
- missing workspace file
- command order wrong

Fix layer:
- workflow config
- Jenkinsfile
- pipeline scripts

## Credential or identity failures

Signals:
- 401/403
- token missing
- workload identity not authorized
- secret resolves to empty string

Fix layer:
- credential store
- role assignment / IAM
- secret bootstrap
- pipeline env handling

## Environment mismatch

Signals:
- works locally, fails in CI
- different env vars
- missing tools or different versions
- placeholder/example values overriding real values

Fix layer:
- pipeline environment setup
- deterministic config injection
- version pinning

## Terraform and infra validation

Signals:
- `terraform validate` or `plan` fails
- plan diffs unexpected because CI uses example vars
- live state differs from Git

Fix layer:
- Terraform code if the config is wrong
- pipeline var injection if CI input is wrong
- state reconciliation if live drift exists

## Deployment and GitOps convergence

Signals:
- build passes but deployment app is unhealthy
- Argo/Flux pinned to stale revision
- invalid manifest blocks unrelated resources

Fix layer:
- desired manifests
- sync ordering
- CRD/operator bootstrap

## Auto-diagnosis drift

Signals:
- bot issue cites wrong file
- summary omits actual error line
- remediation points to low-confidence guess

Fix layer:
- ignore the bot summary until the raw failure is confirmed
- patch evidence extraction if the tool is systematically misleading

