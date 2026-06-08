#!/usr/bin/env bash
# Re-export BWOC framework skills as Codex plugin skills.
#
# For each skill reported by `bwoc skill list --json` in the workspace pointed
# to by BWOC_WORKSPACE, fetch its manifest via `bwoc skill show <name> --json`
# and emit a lean Codex skill at skills/fw-<name>/SKILL.md.
#
# The generated skills/fw-*/ directories are gitignored — this script is the
# only committed artifact. Re-run it locally to refresh.
#
# Usage:
#   BWOC_WORKSPACE=/path/to/workspace bash scripts/sync-skills.sh
set -euo pipefail

if [[ -z "${BWOC_WORKSPACE:-}" ]]; then
  echo "sync-skills: BWOC_WORKSPACE must be set (path to a BWOC workspace)" >&2
  exit 1
fi

command -v bwoc >/dev/null 2>&1 || { echo "sync-skills: 'bwoc' not found on PATH" >&2; exit 1; }
command -v jq   >/dev/null 2>&1 || { echo "sync-skills: 'jq' not found on PATH" >&2; exit 1; }

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
skills_dir="$repo_root/skills"

# Skill names in the target workspace (empty list is valid → emit nothing).
names="$(bwoc skill list --json --workspace "$BWOC_WORKSPACE" | jq -r '.skills[].name')"

count=0
while IFS= read -r name; do
  [[ -n "$name" ]] || continue

  json="$(bwoc skill show "$name" --json --workspace "$BWOC_WORKSPACE")"

  desc="$(jq -r '.skill.description // ""' <<<"$json")"
  exposes="$(jq -r '(.skill.exposes // []) | join(", ")' <<<"$json")"

  out_dir="$skills_dir/fw-$name"
  mkdir -p "$out_dir"

  {
    printf -- '---\n'
    printf 'name: bwoc-fw-%s\n' "$name"
    printf 'description: %s\n' "$desc"
    printf -- '---\n\n'
    printf '# bwoc-fw-%s\n\n' "$name"
    printf 'Re-exports the BWOC framework skill `%s`.\n\n' "$name"
    printf '%s\n\n' "$desc"
    printf '## Purpose\n\n'
    printf 'Surface the framework skill `%s` to Codex so the agent can invoke it ' "$name"
    printf 'through the `bwoc` CLI without leaving the Codex session.\n\n'
    if [[ -n "$exposes" ]]; then
      printf '## Exposes\n\n%s\n\n' "$exposes"
    fi
    printf '## Spec\n\n'
    printf 'Full contract lives in the workspace at '
    printf '`modules/skills/%s/SPEC.md`. Inspect it with:\n\n' "$name"
    printf '```bash\n'
    printf 'bwoc skill show %s\n' "$name"
    printf '```\n'
  } >"$out_dir/SKILL.md"

  count=$((count + 1))
done <<EOF
$names
EOF

echo "sync-skills: wrote $count skill(s) to skills/fw-*/"
