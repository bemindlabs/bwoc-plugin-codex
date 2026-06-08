#!/usr/bin/env bash
# Regenerate per-verb skills from the live `bwoc` CLI + a template.
#
# This is a declarative plugin (nothing to compile). "Build" here means:
# ensure every wrapped verb has a skills/<name>/SKILL.md. Curated skills that
# already exist are left untouched; only missing ones are scaffolded from
# scripts/templates/verb.SKILL.md.tmpl so the manifest never references a gap.
set -euo pipefail

cd "$(dirname "$0")/.."

TMPL="scripts/templates/verb.SKILL.md.tmpl"

# Verbs this plugin wraps. Keep in sync with the README table.
VERBS=(list status send run chat task team memory)

if ! command -v bwoc >/dev/null 2>&1; then
  echo "build: warning — 'bwoc' not on PATH; scaffolding from template only" >&2
fi

generated=0
for verb in "${VERBS[@]}"; do
  out="skills/bwoc-${verb}/SKILL.md"
  if [[ -f "$out" ]]; then
    echo "keep  $out (curated)"
    continue
  fi

  mkdir -p "skills/bwoc-${verb}"

  # Pull the one-line description straight from `bwoc <verb> --help`.
  desc="Wraps \`bwoc ${verb}\`."
  if command -v bwoc >/dev/null 2>&1; then
    first="$(bwoc "$verb" --help 2>/dev/null | sed -n '1p' || true)"
    [[ -n "$first" ]] && desc="${first} Wraps \`bwoc ${verb}\`."
  fi

  usage="bwoc ${verb}"
  if command -v bwoc >/dev/null 2>&1; then
    u="$(bwoc "$verb" --help 2>/dev/null | sed -n 's/^Usage: //p' | head -n1 || true)"
    [[ -n "$u" ]] && usage="$u"
  fi

  sed \
    -e "s|{{VERB}}|${verb}|g" \
    -e "s|{{DESC}}|${desc}|g" \
    -e "s|{{SUMMARY}}|${desc}|g" \
    -e "s|{{USAGE}}|${usage}|g" \
    -e "s|{{BODY}}|Run \`bwoc ${verb} --help\` for the full flag set.|g" \
    "$TMPL" >"$out"
  echo "gen   $out"
  generated=$((generated + 1))
done

echo "build: done (${generated} generated, $(( ${#VERBS[@]} - generated )) kept)"
