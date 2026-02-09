# Configuration

> Configuration options for `this-is-a-new-idea-r2`.

## Precedence

Configuration is resolved in this order (highest first):

1. CLI flags
2. Environment variables
3. Config file
4. Built-in defaults

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `IDEA_BRIEF_FORMAT` | `markdown` | `brief`: `markdown` or `json`; `score`: `text` or `json` |
| `IDEA_BRIEF_TONE` | `concise` | `concise` or `detailed` |
| `IDEA_BRIEF_CONTEXT` | empty | Additional context included in output |
| `IDEA_BRIEF_CONFIG` | `~/.config/idea-brief-generator/config` | Config file path |

## Configuration File

Default location:

```text
~/.config/idea-brief-generator/config
```

Format:

```text
format=markdown
tone=concise
context=Optional default context text
```

## Options Reference

### `format`

- Type: string
- Allowed: `markdown`, `json`, `text`
- Default: `markdown`
- Env: `IDEA_BRIEF_FORMAT`
- Flag: `--format`

### `tone`

- Type: string
- Allowed: `concise`, `detailed`
- Default: `concise`
- Env: `IDEA_BRIEF_TONE`
- Flag: `--tone`

### `context`

- Type: string
- Default: empty
- Env: `IDEA_BRIEF_CONTEXT`
- Flag: `--context`

### `output`

- Type: file path
- Default: stdout
- Flag: `--output`

### `config`

- Type: file path
- Default: `~/.config/idea-brief-generator/config`
- Env: `IDEA_BRIEF_CONFIG`
- Flag: `--config`
