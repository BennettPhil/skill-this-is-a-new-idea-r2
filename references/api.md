# API Reference

> Complete interface documentation for `this-is-a-new-idea-r2`.

## Commands

### `brief`

**Description**: Generate a structured brief from an idea statement.

**Usage**:
```bash
./scripts/run.sh brief [OPTIONS] "<idea text>"
```

**Arguments**:
| Argument | Required | Description |
|----------|----------|-------------|
| `idea`   | Yes      | Raw idea statement to analyze. |

**Options**:
| Option | Default | Description |
|--------|---------|-------------|
| `--format markdown\|json` | `markdown` | Output format for the `brief` command. |
| `--tone concise\|detailed` | `concise` | Controls detail level in generated text. |
| `--context "<text>"` | empty | Extra context included in analysis. |
| `--output <path>` | stdout | Write output to file instead of terminal. |
| `--config <path>` | `~/.config/idea-brief-generator/config` | Path to config file. |

### `questions`

**Description**: Produce clarifying questions to de-risk the idea.

**Usage**:
```bash
./scripts/run.sh questions [OPTIONS] "<idea text>"
```

**Options**:
| Option | Default | Description |
|--------|---------|-------------|
| `--tone concise\|detailed` | `concise` | How much elaboration each question includes. |
| `--output <path>` | stdout | Write output to file instead of terminal. |
| `--config <path>` | `~/.config/idea-brief-generator/config` | Path to config file. |

### `score`

**Description**: Return quick viability scores (clarity, feasibility, differentiation).

**Usage**:
```bash
./scripts/run.sh score [OPTIONS] "<idea text>"
```

**Options**:
| Option | Default | Description |
|--------|---------|-------------|
| `--format text\|json` | `text` | Score output format. |
| `--context "<text>"` | empty | Context that can improve scoring confidence. |
| `--output <path>` | stdout | Write output to file instead of terminal. |
| `--config <path>` | `~/.config/idea-brief-generator/config` | Path to config file. |

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | Usage error (missing arguments, unknown command, unknown flag) |
| 2 | Invalid input (empty idea) |
| 3 | Runtime failure (config parse or output write failure) |

## Notes

- Commands are deterministic and use lightweight heuristics.
- No network calls are made.
- `brief` supports both markdown and JSON outputs.
