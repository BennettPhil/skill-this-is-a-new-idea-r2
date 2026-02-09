# Examples

> Copy-paste examples for `this-is-a-new-idea-r2`.

## Basic Usage

### Create a markdown brief

```bash
./scripts/run.sh brief "A service that matches seniors with trusted tech tutors"
```

Output (truncated):
```markdown
## Idea Brief
- Idea: A service that matches seniors with trusted tech tutors
- Problem:
- Target Users:
- Value Proposition:
...
```

### Generate clarifying questions

```bash
./scripts/run.sh questions "A service that matches seniors with trusted tech tutors"
```

Output:
```text
1. Who is the primary user and what workflow are they in when this problem occurs?
2. What measurable outcome should improve if this idea succeeds?
3. What data or integrations are required to deliver the core value?
4. What constraints (budget, legal, timeline) limit the first version?
5. What is the smallest test that can validate demand in 2 weeks?
```

## Advanced Usage

### JSON brief with extra context

```bash
./scripts/run.sh brief --format json \
  --context "Pilot in two retirement communities first" \
  "A service that matches seniors with trusted tech tutors"
```

Output:
```json
{"idea":"A service that matches seniors with trusted tech tutors","problem":"Unclear","target_users":"Unclear","value_proposition":"Unclear","go_to_market":"Run interviews, test demand with a small pilot.","risks":["User acquisition may be expensive","Problem urgency is not yet validated"],"next_experiment":"Interview 5 target users and test willingness-to-pay."}
```

### Score and write result to file

```bash
./scripts/run.sh score --format json \
  --output ./idea-score.json \
  "A service that matches seniors with trusted tech tutors"
```

Terminal output:
```text
Wrote output to ./idea-score.json
```

## Error Handling

### Missing command

```bash
./scripts/run.sh
```

Output:
```text
Usage: ./scripts/run.sh <brief|questions|score> [options] "<idea text>"
```

### Empty idea

```bash
./scripts/run.sh brief "   "
```

Output:
```text
Error: idea text cannot be empty
```
