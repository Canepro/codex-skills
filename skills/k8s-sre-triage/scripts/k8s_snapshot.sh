#!/usr/bin/env bash
set -euo pipefail

if ! command -v kubectl >/dev/null 2>&1; then
  echo "kubectl not found on PATH" >&2
  exit 1
fi

echo "== context =="
kubectl config current-context
echo

echo "== nodes =="
kubectl get nodes -o wide
echo

echo "== pods =="
kubectl get pods -A -o wide
echo

echo "== recent-events =="
kubectl get events -A --sort-by=.metadata.creationTimestamp | tail -n 200
echo

echo "== services =="
kubectl get svc -A
echo

echo "== ingress =="
kubectl get ingress -A || true
echo

echo "== pvc =="
kubectl get pvc -A || true
echo

echo "== jobs =="
kubectl get jobs -A || true
echo

echo "== cronjobs =="
kubectl get cronjobs -A || true
