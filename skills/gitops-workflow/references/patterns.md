# GitOps Workflow Patterns

## Repo boundaries

- Keep platform-wide controllers and shared infrastructure separate from application repos when ownership differs materially.
- Avoid splitting repos so finely that promotion and troubleshooting become opaque.

## Promotion

Common models:
- branch or folder per environment
- pull-request promotion between environments
- image tag or version bump promotion

Prefer the model operators can reason about quickly during incidents.

## Application boundaries

- One app object should fail and recover in a coherent way.
- Do not bundle unrelated resources just because they deploy at similar times.
- Separate prerequisites that need different ordering or ownership.

## Secrets

Choose explicitly:
- sealed secrets
- external secret operator
- vault-backed injection

Do not let secret handling become an out-of-band exception to GitOps.

## Anti-patterns

- manual cluster patches as a normal release step
- ambiguous repo ownership
- environment drift that is never reconciled back to Git
- one giant application object that blocks the whole platform
