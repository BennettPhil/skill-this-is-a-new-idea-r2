# Usage Guide

> Step-by-step workflow for turning a rough idea into a decision-ready brief.

## Prerequisites

- Bash 3.2+
- `./scripts/run.sh` marked executable

## Getting Started

### Step 1: Draft a brief

```bash
./scripts/run.sh brief "A browser extension that summarizes long docs for sales teams"
```

Expected output (truncated):
```markdown
## Idea Brief
- Idea: A browser extension that summarizes long docs for sales teams
- Problem:
- Target Users:
- Value Proposition:
...
```

### Step 2: Identify unknowns

```bash
./scripts/run.sh questions "A browser extension that summarizes long docs for sales teams"
```

Expected output:
```text
1. Who is the primary user and what workflow are they in when this problem occurs?
2. What measurable outcome should improve if this idea succeeds?
3. What data or integrations are required to deliver the core value?
4. What constraints (budget, legal, timeline) limit the first version?
5. What is the smallest test that can validate demand in 2 weeks?
```

### Step 3: Check viability quickly

```bash
./scripts/run.sh score --format json "A browser extension that summarizes long docs for sales teams"
```

Expected output:
```json
{"clarity":7,"feasibility":7,"differentiation":6,"confidence":"medium"}
```

## Common Tasks

### Include additional context

```bash
./scripts/run.sh brief --context "Targeting B2B teams with existing CRM integrations" \
  "A browser extension that summarizes long docs for sales teams"
```

### Save outputs to files

```bash
./scripts/run.sh brief --output ./brief.md "A marketplace for booking home EV charger installs"
./scripts/run.sh score --format json --output ./score.json \
  "A marketplace for booking home EV charger installs"
```

## Troubleshooting

### Empty input

**Symptom**: `Error: idea text cannot be empty`  
**Cause**: The idea argument is missing or blank.  
**Fix**: Provide non-empty quoted text after the command.

### Unknown option

**Symptom**: `Error: unknown option --foo`  
**Cause**: Unsupported flag was passed.  
**Fix**: Use options documented in [API Reference](./api.md).

### Output file write error

**Symptom**: `Error: could not write to output path ...`  
**Cause**: Missing permissions or invalid directory.  
**Fix**: Use a writable path and retry.
