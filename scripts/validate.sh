#!/usr/bin/env bash
set -e
jq . .codex-plugin/plugin.json >/dev/null && echo "plugin.json OK"
