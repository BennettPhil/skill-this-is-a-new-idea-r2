#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./scripts/run.sh <brief|questions|score> [options] "<idea text>"

Options:
  --format <markdown|json|text>
  --tone <concise|detailed>
  --context <text>
  --output <path>
  --config <path>
EOF
}

err() {
  printf 'Error: %s\n' "$1" >&2
  exit "${2:-1}"
}

trim() {
  local s="$1"
  s="${s#"${s%%[![:space:]]*}"}"
  s="${s%"${s##*[![:space:]]}"}"
  printf '%s' "$s"
}

score_idea() {
  local idea="$1"
  local context="$2"
  local len clarity feasibility diff confidence
  len=${#idea}
  clarity=5
  feasibility=6
  diff=5

  if [[ $len -ge 40 ]]; then clarity=$((clarity + 2)); fi
  if [[ "$idea" == *"for "* || "$idea" == *"helps "* ]]; then clarity=$((clarity + 1)); fi
  if [[ "$idea" == *"AI"* || "$idea" == *"blockchain"* ]]; then feasibility=$((feasibility - 1)); fi
  if [[ "$idea" == *"marketplace"* || "$idea" == *"platform"* ]]; then feasibility=$((feasibility - 1)); fi
  if [[ "$idea" == *"niche"* || "$idea" == *"local"* ]]; then diff=$((diff + 1)); fi
  if [[ -n "$context" ]]; then clarity=$((clarity + 1)); fi

  (( clarity > 10 )) && clarity=10
  (( feasibility > 10 )) && feasibility=10
  (( diff > 10 )) && diff=10
  (( clarity < 1 )) && clarity=1
  (( feasibility < 1 )) && feasibility=1
  (( diff < 1 )) && diff=1

  if (( clarity >= 7 && feasibility >= 7 )); then
    confidence="medium"
  else
    confidence="low"
  fi

  printf '%s|%s|%s|%s\n' "$clarity" "$feasibility" "$diff" "$confidence"
}

render_questions() {
  local tone="$1"
  local suffix=""
  if [[ "$tone" == "detailed" ]]; then
    suffix=" (include evidence, metrics, and owner)"
  fi
  cat <<EOF
1. Who is the primary user and what workflow are they in when this problem occurs?$suffix
2. What measurable outcome should improve if this idea succeeds?$suffix
3. What data or integrations are required to deliver the core value?$suffix
4. What constraints (budget, legal, timeline) limit the first version?$suffix
5. What is the smallest test that can validate demand in 2 weeks?$suffix
EOF
}

render_brief_markdown() {
  local idea="$1"
  local context="$2"
  local tone="$3"
  cat <<EOF
## Idea Brief
- Idea: $idea
- Problem: Unclear
- Target Users: Unclear
- Value Proposition: Unclear
- Context: ${context:-None provided}
- Go-to-Market: Run interviews, then test demand with a small pilot.
- Risks:
  - User acquisition may be expensive.
  - Problem urgency is not yet validated.
- Next Experiment: Interview 5 target users and test willingness-to-pay.
EOF
  if [[ "$tone" == "detailed" ]]; then
    cat <<'EOF'

## Detail Expansion
- Success Metric: Define a single leading metric before building.
- Channel Hypothesis: Choose one acquisition channel for the first test.
- Timeline: Keep first validation cycle under 14 days.
EOF
  fi
}

render_brief_json() {
  local idea="$1"
  local context="$2"
  cat <<EOF
{"idea":"$idea","problem":"Unclear","target_users":"Unclear","value_proposition":"Unclear","context":"${context:-}","go_to_market":"Run interviews, then test demand with a small pilot.","risks":["User acquisition may be expensive","Problem urgency is not yet validated"],"next_experiment":"Interview 5 target users and test willingness-to-pay."}
EOF
}

write_or_print() {
  local output_path="$1"
  local body="$2"
  if [[ -n "$output_path" ]]; then
    if ! printf '%s\n' "$body" > "$output_path"; then
      err "could not write to output path $output_path" 3
    fi
    printf 'Wrote output to %s\n' "$output_path"
  else
    printf '%s\n' "$body"
  fi
}

load_config() {
  local path="$1"
  [[ -f "$path" ]] || return 0
  while IFS='=' read -r k v; do
    [[ -z "${k// }" ]] && continue
    [[ "$k" =~ ^[[:space:]]*# ]] && continue
    k="$(trim "$k")"
    v="$(trim "${v:-}")"
    case "$k" in
      format) cfg_format="$v" ;;
      tone) cfg_tone="$v" ;;
      context) cfg_context="$v" ;;
      *) ;;
    esac
  done < "$path"
}

command="${1:-}"
[[ -z "$command" ]] && { usage; exit 1; }
shift || true

cfg_file="${IDEA_BRIEF_CONFIG:-$HOME/.config/idea-brief-generator/config}"
cfg_format=""
cfg_tone=""
cfg_context=""
load_config "$cfg_file"

format="${cfg_format:-${IDEA_BRIEF_FORMAT:-}}"
tone="${cfg_tone:-${IDEA_BRIEF_TONE:-concise}}"
context="${cfg_context:-${IDEA_BRIEF_CONTEXT:-}}"
output_path=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --format)
      shift; [[ $# -gt 0 ]] || err "missing value for --format"
      format="$1"
      ;;
    --tone)
      shift; [[ $# -gt 0 ]] || err "missing value for --tone"
      tone="$1"
      ;;
    --context)
      shift; [[ $# -gt 0 ]] || err "missing value for --context"
      context="$1"
      ;;
    --output)
      shift; [[ $# -gt 0 ]] || err "missing value for --output"
      output_path="$1"
      ;;
    --config)
      shift; [[ $# -gt 0 ]] || err "missing value for --config"
      cfg_file="$1"
      ;;
    --help|-h)
      usage; exit 0
      ;;
    --*)
      err "unknown option $1"
      ;;
    *)
      break
      ;;
  esac
  shift || true
done

idea="${*:-}"
idea="$(trim "$idea")"
[[ -z "$idea" ]] && err "idea text cannot be empty" 2

case "$command" in
  brief)
    [[ -z "$format" ]] && format="markdown"
    [[ "$format" == "markdown" || "$format" == "json" ]] || err "brief supports --format markdown|json"
    [[ "$tone" == "concise" || "$tone" == "detailed" ]] || err "tone must be concise|detailed"
    if [[ "$format" == "markdown" ]]; then
      body="$(render_brief_markdown "$idea" "$context" "$tone")"
    else
      body="$(render_brief_json "$idea" "$context")"
    fi
    write_or_print "$output_path" "$body"
    ;;
  questions)
    [[ "$tone" == "concise" || "$tone" == "detailed" ]] || err "tone must be concise|detailed"
    body="$(render_questions "$tone")"
    write_or_print "$output_path" "$body"
    ;;
  score)
    [[ -z "$format" ]] && format="text"
    [[ "$format" == "text" || "$format" == "json" ]] || err "score supports --format text|json"
    IFS='|' read -r clarity feasibility diff confidence <<< "$(score_idea "$idea" "$context")"
    if [[ "$format" == "json" ]]; then
      body="{\"clarity\":$clarity,\"feasibility\":$feasibility,\"differentiation\":$diff,\"confidence\":\"$confidence\"}"
    else
      body="clarity=$clarity feasibility=$feasibility differentiation=$diff confidence=$confidence"
    fi
    write_or_print "$output_path" "$body"
    ;;
  *)
    usage
    err "unknown command: $command"
    ;;
esac
