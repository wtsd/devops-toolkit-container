#!/usr/bin/env bash
# One-time setup per container start (idempotent)
set -euo pipefail

# Create handy symlinks into workspace
mkdir -p /workspace/creds || true
[[ -d "$HOME/.kube" && ! -e /workspace/.kube ]] && ln -s "$HOME/.kube" /workspace/.kube || true
[[ -d "$HOME/.aws" && ! -e /workspace/.aws ]] && ln -s "$HOME/.aws" /workspace/.aws || true
[[ -d "$HOME/.config/gcloud" && ! -e /workspace/.gcloud ]] && ln -s "$HOME/.config/gcloud" /workspace/.gcloud || true
echo "# Put env vars here; scripts will source this file" > /workspace/.env.example || true
