---
name: codex-app-server-backend-adapter
description: Design, implement, and troubleshoot backend services that use Codex app-server or Codex OAuth-backed execution. Use when comparing Codex CLI, codex app-server --stdio, managed app-server daemon, mounted OAuth session material, WebSocket transports, provider health checks, timeouts, or production-like Codex provider lanes.
---

# Codex App Server Backend Adapter

Use this skill when a service wants Codex-backed reasoning without relying on a human desktop action for each request.

## First distinction

Separate two questions:

- Is Codex app-server a programmable first-party surface? Yes. It can support app-state reads, thread operations, repair flows, daemon checks, and stdio integrations.
- Should a long-running backend casually depend on interactive desktop machinery? No. A service needs an explicit provider contract, health checks, auth boundaries, timeouts, and fallback behavior.

Do not dismiss app-server as "just UI plumbing." Also do not pretend an interactive client path is production-ready just because it works once.

## Provider contract

Define these before wiring a backend:

- transport: `stdio`, managed daemon, WebSocket, or explicit CLI execution
- auth source: OAuth session material, local Codex state, service account, or API key
- startup behavior: one process per request or long-running provider
- concurrency: max in-flight requests, request isolation strategy, and per-provider queue limit
- backpressure: what happens when concurrency is exceeded and how the caller is signaled
- provider isolation: separate adapters or worker pools per provider, tenant, or model family when blast radius must be bounded
- retry policy: allowed retryable failures, retry limit, and backoff policy
- circuit breaker policy: failure ratio threshold, open state duration, and half-open probe behavior
- idempotency: required idempotency key or dedupe token for any provider-triggered state change
- timeout: model turn timeout and process timeout
- sandbox: filesystem/network policy, cwd, and allowed mounted paths
- output contract: JSON schema, validation, and failure behavior
- observability: request id, run id, provider version, model, token usage when available
- fallback: whether fallback is allowed and how reviewers see it

## Implementation rules

- Prefer a small provider adapter with `draft()` or equivalent business method, plus `info()` for health.
- Expose provider transport, model, timeout, sandbox, and auth-required state through `/health`.
- Keep provider failure visible. Do not silently swap providers without recording `fallbackUsed` or equivalent metadata.
- Enforce request isolation and concurrency limits per provider; use bounded queues and backpressure instead of unbounded fan-out.
- Add retry and circuit breaker policies around external provider calls. Retry only safe calls with bounded attempts and jittered backoff; trip the circuit breaker on repeated failure and fail fast while open.
- Prevent duplicate mutations by using idempotency keys or dedupe guards before any downstream write path is executed.
- Validate model output before downstream mutation.
- Treat OAuth/session files as credentials. Do not print, copy into docs, or commit them.
- If app-server protocol support is uncertain, make a small protocol probe first and keep it separate from business logic.

## Checks

Before calling a provider lane ready:

- service health returns provider and transport and current circuit-breaker state
- a safe fixture request completes
- concurrency and request isolation hold under parallel load without shared state bleed
- saturation and backpressure behavior are tested, with explicit rejection or throttling signal
- timeout behavior is known
- retry and backoff path is tested with transient failures and does not produce duplicate mutation
- invalid output is rejected or routed to human review
- missing local skill/context is surfaced as a private reviewer limitation, not hidden
- version and build metadata identify the exact adapter code path

## Common failure modes

Interactive path assumed headless: the code depends on state only present in a desktop session. Fix by mounting the required Codex state explicitly or using a supported stdio/client path.

Daemon version drift: CLI update succeeds but managed app-server still runs an older version. Restart the app-server daemon and verify the daemon version.

Context unavailable: provider can run but cannot read the expected skills or repo files. Surface the limitation and repair the mount or cwd.

Timeouts look like bad model output: distinguish provider timeout, process failure, and validation failure in run metadata.

## Workflow coordination

Use project-specific skills for the product contract. Use `infisical-secrets-management` before moving or injecting credentials. Use `vincent-workflow` when adapter decisions create durable architecture, blocker, or closeout obligations. Use `codex-html-report` for durable reader-facing comparison or integration reports. Use `codex-closeout` for end-of-work proof hygiene when provider behavior changes.
