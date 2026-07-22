---
name: zoho-desk-api-notes
description: Configure, post, and troubleshoot Zoho Desk private ticket notes through API or n8n OAuth workflows. Use when working with Zoho Desk ticket comments, private case notes, orgId headers, OAuth scopes, visible ticket numbers versus internal ticket ids, SCOPE_MISMATCH, URL_NOT_FOUND, or safe first-response draft workflows.
---

# Zoho Desk API Notes

Use this skill when an automation writes or debugs Zoho Desk ticket comments. The main risk is mixing the visible ticket number with Zoho's long internal ticket id.

## Private note contract

Use the Zoho Accounts OAuth domain and Zoho Desk API domain from the same data center. The OAuth and API hosts must match.
Use matching pairs such as:
`accounts.zoho.com` with `desk.zoho.com`,
`accounts.zoho.eu` with `desk.zoho.eu`,
`accounts.zoho.in` with `desk.zoho.in`,
and `accounts.zoho.com.au` with `desk.zoho.com.au`.

Use the internal ticket id in the endpoint:

```text
POST https://desk.zoho.com/api/v1/tickets/{internalTicketId}/comments
```

Required headers:

```text
orgId: <Zoho org id>
Content-Type: application/json
```

Private note body:

```json
{
  "content": "<html or plain text note>",
  "contentType": "html",
  "isPublic": false
}
```

Do not use the visible ticket number in `{internalTicketId}`. Search or fetch the ticket first, then post against the long id.
Validate the internal id with a long numeric regex such as `^[0-9]{12,}$` before posting.
If `contentType` is `html`, escape or sanitize customer-provided text before putting it in the note body.

## OAuth scope checklist

For ticket lookup and private comments, the n8n or API OAuth credential usually needs:

```text
Desk.tickets.UPDATE,Desk.tickets.READ,Desk.basic.READ,Desk.search.READ
```

Reconnect the OAuth credential after changing scopes. Existing access tokens will not magically gain new scopes.

## Ticket id workflow

1. Accept a visible ticket number only as operator input or webhook fallback.
2. Resolve it through Zoho search or ticket fetch.
3. Validate the returned id with a long numeric-id guard.
4. Carry both values separately:
   - `ticketNumber` for human display
   - `ticketId` or `zohoTicketId` for API endpoints
5. Fail before the final POST if the API endpoint id is short or missing.
6. Keep the final POST disabled until a dry run or lookup-only validation proves ticket resolution, headers, and note body shape.

## Common errors

`404 URL_NOT_FOUND`: likely wrong endpoint path, missing `/comments`, visible ticket number used as the path id, stale internal id, or the workflow was run from a final HTTP node without the lookup output.

`403 SCOPE_MISMATCH`: OAuth credential lacks the required Desk scope. Update scopes, reconnect, and rerun the workflow.

`401`: OAuth credential expired or the wrong credential is bound to the HTTP node.

`429`: Zoho API rate limit hit. Do not blind rerun; read `Retry-After`, wait, and retry with backoff (for example exponential backoff with jitter) so you honor the rate limit.

Empty or wrong department/org: check the `orgId` header and the Zoho data center domain.

## Safety rules

- Never create a public comment unless the workflow is explicitly approved to send customer-facing text.
- Prefer private notes for first-pass analysis, triage, and customer draft review.
- Do not print OAuth tokens, refresh tokens, cookies, or credential internals.
- Keep customer drafts clearly marked `NOT SENT`.
- Include enough run metadata in private notes for reviewers to identify the automation version and source.
- Include concrete audit fields in private notes when automation writes them: workflow name, workflow execution id, timestamp, automation version, source, and credential name. Never include credential secret contents.

## Workflow coordination

Use `n8n-workflow-api-deploy` when the Zoho note is created by an n8n workflow.
Use `infisical-secrets-management` for credential or token handling. Use
repo-local skills such as `support-agent-ops` for project-specific note
formatting and approval boundaries. Use `rocketchat-support-ticket` for the
support-lane proof pack when Zoho notes are part of case-builder or
support-agent work: design proof, local proof, runtime proof, workflow proof,
safety proof, and approved live E2E proof.
