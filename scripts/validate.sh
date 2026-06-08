#!/usr/bin/env bash
# Validate the Codex plugin's JSON artifacts and skill layout.
set -euo pipefail

cd "$(dirname "$0")/.."

fail=0

check_json() {
  local f="$1"
  if [[ ! -f "$f" ]]; then
    echo "MISSING: $f" >&2
    fail=1
    return
  fi
  if jq . "$f" >/dev/null 2>&1; then
    echo "OK   $f"
  else
    echo "BAD JSON: $f" >&2
    fail=1
  fi
}

check_json ".codex-plugin/plugin.json"
check_json "hooks/hooks.json"
check_json ".agents/plugins/marketplace.json"

# Every skill must have a SKILL.md.
for d in skills/*/; do
  [[ -d "$d" ]] || continue
  if [[ -f "${d}SKILL.md" ]]; then
    echo "OK   ${d}SKILL.md"
  else
    echo "MISSING SKILL.md in $d" >&2
    fail=1
  fi
done

if [[ "$fail" -ne 0 ]]; then
  echo "validate: FAILED" >&2
  exit 1
fi
echo "validate: PASSED"
