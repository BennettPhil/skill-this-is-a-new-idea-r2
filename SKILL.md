---
name: this-is-a-new-idea-r2
description: Turn a rough idea into a structured brief, clarifying questions, and quick viability scores.
version: 0.1.0
license: Apache-2.0
---

# This Is A New Idea R2

## Purpose

Convert a short or vague idea into a practical planning artifact: a structured brief, a list of
clarifying questions, and fast viability signals.

## Quick Start

```bash
./scripts/run.sh brief "A mobile app that helps neighbors share tools"
./scripts/run.sh questions "A mobile app that helps neighbors share tools"
./scripts/run.sh score "A mobile app that helps neighbors share tools"
```

## Reference Index

- [API Reference](./references/api.md): Commands, flags, arguments, and exit codes.
- [Usage Guide](./references/usage-guide.md): Step-by-step workflow from raw idea to action plan.
- [Configuration](./references/configuration.md): Defaults, environment variables, and config file.
- [Examples](./references/examples.md): Copy-paste examples with expected output.

## Implementation

Core behavior is implemented in `./scripts/run.sh`.
