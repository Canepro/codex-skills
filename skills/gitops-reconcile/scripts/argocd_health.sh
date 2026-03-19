#!/usr/bin/env bash
set -euo pipefail

if ! command -v argocd >/dev/null 2>&1; then
  echo "argocd CLI not found on PATH" >&2
  exit 1
fi

echo "== app-list =="
argocd app list
echo

if [[ $# -eq 1 ]]; then
  app="$1"
  echo "== app-get:$app =="
  argocd app get "$app"
fi

