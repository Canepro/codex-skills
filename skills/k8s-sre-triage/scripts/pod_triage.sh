#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <namespace> <pod>" >&2
  exit 1
fi

if ! command -v kubectl >/dev/null 2>&1; then
  echo "kubectl not found on PATH" >&2
  exit 1
fi

ns="$1"
pod="$2"

echo "== pod =="
kubectl get pod "$pod" -n "$ns" -o wide
echo

echo "== owner =="
kubectl get pod "$pod" -n "$ns" -o jsonpath='{range .metadata.ownerReferences[*]}{.kind}{" "}{.name}{"\n"}{end}' || true
echo

echo "== describe =="
kubectl describe pod "$pod" -n "$ns"
echo

echo "== logs-current =="
kubectl logs "$pod" -n "$ns" --all-containers --tail=200 || true
echo

echo "== logs-previous =="
kubectl logs "$pod" -n "$ns" --all-containers --previous --tail=200 || true

