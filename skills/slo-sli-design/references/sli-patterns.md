# SLI Patterns

## API services

Common user-facing indicators:
- successful request ratio
- latency under threshold for key endpoints
- freshness of read-after-write behavior when relevant

## Background jobs

Common indicators:
- completion success ratio
- completion within deadline
- queue delay or freshness for time-sensitive work

## Platforms

Common indicators:
- successful deployment or provisioning ratio
- control-plane latency for key actions
- platform API availability for internal users

## User journeys

Prefer journey SLIs when multiple services must work together:
- login completes successfully
- checkout completes within acceptable latency
- report generation finishes and becomes available

## Burn alerts

Typical pattern:
- one fast-burn alert for acute degradation
- one slow-burn alert for sustained erosion

## Anti-patterns

- using CPU or memory directly as SLIs
- using backend-only metrics with no user meaning
- setting objectives with no operational consequence
- defining so many SLOs that none get reviewed
