#!/usr/bin/env bash
set -e

NS=$1

kubectl wait --namespace $NS \
  --for=condition=ready pod \
  --all \
  --timeout=180s