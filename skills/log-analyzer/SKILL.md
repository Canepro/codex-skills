---
name: log-analyzer
description: Analyze provided log artifacts. Files, pasted snippets, stack traces, HAR excerpts, ticket attachments, and error timelines become bounded findings, correlation, and support-safe next steps. Not for live-system triage (k8s-sre-triage, prometheus-grafana-triage, ci-pipeline-triage own those) or LogQL and Loki work (loki).
metadata:
  short-description: Support-safe log analysis
---

# Log analyzer

Use this skill to turn raw logs into evidence-backed findings. Keep the output bounded, source-aware, and useful for support tickets, incident notes, bug reports, or escalation summaries.

## Operating rules

- Preserve exact timestamps, timezones, request IDs, user IDs, error codes, paths, versions, and filenames as evidence.
- Separate observed facts from inference. Use `Observed`, `Likely`, and `Unknown` instead of blending certainty levels.
- Do not infer from partial logs as if they cover the full incident window.
- Do not claim a file shows something unless the content was actually inspected. Attachment metadata is not log evidence.
- Redact or summarize secrets, tokens, passwords, cookies, authorization headers, license keys, private URLs, and unnecessary personal data.
- Prefer concise findings over long reports. Expand only when the user asks for deep analysis.

## Workflow

1. **Establish provenance.**
   - Identify where the log came from: pasted text, local file, exported ticket attachment, command output, HAR, screenshot OCR, or unknown source.
   - Record filename, line range, time window, timezone, and whether the log is complete or partial.

2. **Identify format and scope.**
   - Detect format: JSON, syslog, journalctl, Kubernetes logs, web server logs, browser console, HAR, stack trace, or custom application logs.
   - Identify the component of the application under investigation: application server (for example a Rocket.Chat app), database, reverse proxy, Kubernetes, client app, identity provider, API, job worker, or unknown.

3. **Extract signals.**
   - Errors, warnings, exceptions, failed requests, status codes, retry loops, restarts, timeouts, auth failures, database errors, and config warnings.
   - Group repeated messages by exact or normalized signature.
   - Build a short timeline when timestamps are present.

4. **Correlate carefully.**
   - Link events only when timestamps, request IDs, user/session IDs, pod names, or causal sequence support the link.
   - Flag missing context needed to prove root cause.

5. **Produce support-ready output.**
   - Use the smallest useful format for the caller: findings for an L1 note, customer-safe summary, L3 escalation evidence, Jira comment, or internal investigation note.

## Output format

```markdown
## Log findings

Source:
- [filename/source, line range if known, time window, timezone, complete or partial]

Observed:
- [Exact evidence from the logs.]

Likely:
- [Inference supported by the observed evidence.]

Unknown / gaps:
- [What the logs do not show, missing time range, missing component, or needed follow-up evidence.]

Next checks:
- [One to three targeted checks, commands, or questions.]

Customer-safe summary:
- [Optional. Include only if the caller needs customer-facing wording.]
```

## Related skills

- Writing LogQL or configuring Loki rather than reading pasted logs: `loki`
- Loki label strategy and slow-query diagnosis: `loki-label-analyzer`
- Suspicious patterns that may be an attack rather than a fault (repeated auth failures, scanning, odd traffic, possible intrusion): `adversary-informed-defense`
- Live incident on a running system: hand to the matching triage skill (`k8s-sre-triage`, `prometheus-grafana-triage`, `ci-pipeline-triage`) once artifact analysis points there.

## Support handoff guidance

- For customer replies, include only customer-safe conclusions and documented next steps.
- For L1 handoffs, include exact evidence plus the next owner/action.
- For L3 escalations, include raw error signatures, timestamps, versions, reproduction clues, and what was ruled out.
- For Jira comments, compress to impact, evidence, current hypothesis, and ask.

## Workflow Coordination

This skill owns its domain work. Use `vincent-workflow` for durable decisions, blockers, resume handoffs, known issues, commit/push/cleanup obligations, or project-local follow-up state. Use `codex-closeout` for final chat delivery, `codex-html-report` for durable reader-facing proof, and `second-brain-context` only for cross-repo or future local-brain retrieval.
