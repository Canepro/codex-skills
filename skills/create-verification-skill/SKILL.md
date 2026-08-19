---
name: create-verification-skill
description: Create a project-local skill that drives a real application through its user-facing surface and captures durable proof. Use when a repository lacks a repeatable way for agents to verify UI, CLI, API, service, or desktop behavior.
metadata:
  upstream: https://github.com/cursor/plugins/tree/main/pstack/skills/create-verification-skill
  upstream-commit: 60c641e4fad674784b30abcf9f8915dea39df38d
  adapted-for: Agent Skills multi-harness layout
---

# Create a verification skill

Create one repository-owned skill that another agent can use cold to launch the
real application, exercise a user-facing feature, capture evidence, and clean
up only what it started.

This workflow adapts pstack's `create-verification-skill` for Codex, Claude, and
Cursor. Keep one canonical copy. Do not create divergent instructions for each
harness.

## Locate the canonical directory

Use the repository's established agent-skill directory when one exists.
Otherwise use `.agents/skills/verify-<app>/` as the canonical location. Add a
compatibility link under `.cursor/skills/` or `.claude/skills/` only when that
harness does not discover the canonical directory and the repository already
permits links. Never maintain copied variants.

## Inspect before writing

Determine these facts from the repository before asking the user:

- The primary user-facing surface and any secondary surfaces.
- The repository's documented start command, required environment, readiness
  signal, and teardown path.
- The closest existing driver: Playwright, Cypress, PTY, `expect`, HTTP, a
  debug protocol, or another repo-owned harness.
- Evidence the driver can retain: screenshots, terminal output, response data,
  logs, exit codes, files, or database state.
- Whether two verification instances can run safely in parallel. If not, make
  the generated skill refuse to share or double-drive an instance.

If the application does not start from the current checkout, diagnose or report
that first. Do not write permanent instructions against a broken baseline.

## Generate the skill

Write `SKILL.md` with valid frontmatter and these concrete sections:

- **Launch:** Exact command, loopback bind for temporary network services,
  readiness check, and teardown. Record the process or container identity that
  this run owns. Never kill by broad process name.
- **Doctor:** One read-only command that proves the expected build or version is
  worth driving and that the listener is bound no wider than intended.
- **Drive:** Real commands or stable selectors from this repository. Prefer
  accessibility labels, test ids, prompt strings, routes, and protocol fields
  over screen coordinates.
- **Evidence:** Where proof is stored and what observable result makes each
  feature pass. Exercise the user path, capture the action and result, and
  verify material side effects. A dry-run label is not proof of no writes.
- **Cleanup:** Remove only instances and scratch state created by the run.
  Evidence must survive cleanup.
- **Feature map:** An index and one short file per important user-facing
  feature, initially the top three to five. Each feature states how a user
  reaches it, how the harness drives it, the observable success state, and
  known prerequisites.

Add helper scripts only when deterministic mechanics justify them. Document
their exact invocation and make them fail loudly.

## Prove the generated skill

Run its launch, doctor, one real feature drive, evidence capture, and cleanup.
After cleanup, confirm that the evidence remains and the listener or process is
gone. Fix the generated instructions and repeat until that full path works.

The deliverable is not complete until another agent can follow the skill
without relying on facts left only in this conversation.

