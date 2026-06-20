---
name: adversary-informed-defense
description: Use when work needs attacker-method knowledge for defensive outcomes. Triggers include deciding whether suspicious log lines, repeated auth failures, or odd traffic in a ticket is an attack or a fault; CVE and exposure triage ("are we affected", "is this exploitable"); hardening reviews of Kubernetes, CI/CD, or Terraform surfaces; purple-team planning; detection engineering; incident reconstruction; external security-skill intake; or evaluating offensive tools, repos, and workflows for safe local use.
---

# Adversary-Informed Defense

Use this skill when defensive security work benefits from understanding offensive procedures. The goal is to make the defender sharper without turning an agent into an unbounded exploitation runner.

## When To Use

Use this skill for:

- evaluating external cybersecurity skill packs or playbooks
- deciding whether offensive workflows belong in the local toolkit
- turning attack procedures into detections, hardening tasks, tabletop exercises, or incident reconstruction steps
- purple-team planning in owned, authorized, or lab environments
- reviewing exploit, phishing, cracking, credential-access, malware, or C2-related material for defensive value

Do not use this skill as approval to perform active testing. It defines the gates before active testing can happen.

## Default Posture

Start in defensive-analysis mode:

1. Identify the defensive objective: detection, hardening, triage, containment, recovery, training, or validation.
2. State the authorized scope before any active step.
3. Identify the defensive objective and authorized scope in the same review summary before moving beyond read-only work.
4. Prefer read-only analysis, detection mapping, configuration review, and lab-only reproduction.
5. Treat secret values, credentials, tokens, hashes, dumps, cookies, private keys, and customer data as separate approval boundaries. Require consent before handling, transmitting, or deriving sensitive values.
6. If authorization is absent or unclear, refuse any weaponization, stealth, persistence, or exfiltration actions. Return only defensive alternatives such as threat modeling, containment, recovery, detection mapping, or tabletop exercises.

## Workflow Tiers

Classify the workflow before using it.

### Tier 1: Always Safe

These workflows are safe to load and use by default:

- detection engineering
- hardening and configuration review
- incident response and containment planning
- log analysis and forensics on approved evidence
- SIEM, EDR, cloud audit, Kubernetes audit, and GitHub Actions security review
- vulnerability triage and patch prioritization

### Tier 2: Purple-Team Authorized

These workflows are useful but require explicit owned-scope or lab confirmation before execution:

- Kerberoasting or Active Directory attack simulation
- web cache poisoning, SSRF, JWT, OAuth, IDOR, XSS, request smuggling, and API abuse testing
- phishing simulation and social-engineering exercises
- wireless testing
- exploit validation against owned systems
- controlled scanning beyond local files or repository state

Without authorization, use these only to produce detections, expected artifacts, test plans, or mitigations.

### Tier 3: High-Risk Lab Only

These workflows must stay reference-only unless the user explicitly approves a controlled lab or owned environment for the current task:

- credential extraction or hash cracking
- malware execution, detonation, unpacking, or live behavioral testing
- C2 framework setup or operation
- phishing kit operation
- destructive ransomware simulation
- exploit chains that can disrupt systems or expose data

Treat live infra as out of scope for Tier 3 unless the user explicitly approves the exact owned target, test window, rollback plan, and expected blast radius in the current task.

For Tier 3, keep outputs redacted and avoid printing sensitive values. Prefer synthetic data. If the request asks for weaponization, stealth, persistence, or exfiltration instructions, decline the request and provide defensive alternatives only, such as detections, hardening tasks, and recovery guidance.

## External Skill Pack Intake

Before recommending, importing, or installing an external security skill pack:

1. Check the repository's open issues and pull requests for quality, safety, stale bugs, stub workflows, naming disputes, and pending fixes.
2. Record the inspected commit or release tag.
3. Verify license compatibility.
4. Run any provided validator if it is safe and local.
5. Inspect representative skills from each risky category, not only the README.
6. Check scripts for subprocess calls, network calls, credential handling, destructive actions, and dependency assumptions.
7. Classify candidate skills into Tier 1, Tier 2, and Tier 3 before local adoption.
8. Prefer curated import over bulk installation when the pack mixes defensive, offensive, and high-risk workflows.

## Naming Rules

Use names that describe the defensive purpose rather than the attack spectacle.

Good names:

- `adversary-informed-defense`
- `purple-team-validation`
- `detection-engineering`
- `security-skill-intake`
- `incident-reconstruction`

Avoid names that make the default behavior sound like exploitation, autonomous attacks, payload execution, or unsupervised red-team activity.

If importing a specific external skill, preserve its source attribution but wrap it in local trigger rules when needed.

## Output Shape

For intake or adoption decisions, report:

- source repo, commit, license, and maintenance state
- open issue and PR signals that affect adoption
- useful defensive workflows
- risky workflows and their tier
- scripts or commands that need audit before execution
- recommended local name and trigger rules
- whether to install, curate, reference only, or skip

For live security work, report:

- authorized scope
- selected tier
- defensive objective
- evidence gathered
- actions taken or intentionally not taken
- residual risk and next approval needed
- consent, final submission, live infra, Infisical, or secret-boundary gates that were avoided or still need approval
- attacker-method reasoning with concrete detection artifacts:
  - telemetry sources
  - indicators
  - alert logic and siem query
  - validation data (for example replay traces, benign vs malicious samples, and false-positive checks)

## Related Skills

- Use `log-analyzer` or `rocketchat-log-analysis` first when the evidence is raw logs; come back here when the question becomes "is this an attack and what would the attacker do next".
- Use `k8s-sre-triage` for cluster faults; route here when compromise is a live hypothesis.
- Use `security-best-practices` for language-level secure-coding review; this skill owns attacker-method reasoning, detection mapping, and exposure assessment.
- Use `security-ownership-map` when the question is who owns the sensitive code rather than how it would be attacked.

## Workflow Coordination

This skill owns its domain work. Use `vincent-workflow` for durable decisions, blockers, resume handoffs, known issues, commit/push/cleanup obligations, or project-local follow-up state. Use `codex-closeout` for final chat delivery, `codex-html-report` for durable reader-facing proof, and `second-brain-context` only for cross-repo or future local-brain retrieval.
