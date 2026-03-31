# Support Templates

Use these patterns when the user asks for customer-facing or internal support wording.

## Internal note

```text
Note:
===============
Ticket issue:
- <plain-English summary of the ask>
- <scope and affected surface>
- <risk, impact, or supportability angle>

What has been done so far:
- <facts checked>
- <controls tested or documented>
- <finding and recommendation>

Next steps:
<owner or waiting state>
```

## Customer email

```text
Hello <name>,

Thanks for your patience while we reviewed this.

From what you have described, the requirement is to <plain-English ask>.

Based on the evidence reviewed, <outcome>.

The supported options we would recommend are:
- <recommended option with rationale>
- <secondary option with trade-off if needed>

At this stage, <product gap or next action if applicable>.

If helpful, we can also provide <step-by-step guidance / validation steps / admin path>.

Best regards,
<engineer name>
```

## Escalation note

```text
Escalation summary:
- Customer ask: <one line>
- Current impact: <one line>
- Evidence gathered: <facts only>
- What has been ruled out: <facts only>
- Why escalation is needed: <product gap / suspected defect / unsupported behavior / missing backend visibility>
- Ask to next team: <specific question or action>
```
