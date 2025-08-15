#!/usr/bin/env bash
set -euo pipefail

# Ensure home dirs exist and are writable
mkdir -p "${HOME}/.aws" "${HOME}/.config/gcloud" "${HOME}/.kube" "${HOME}/.cf" "${HOME}/.terraform.d" "${HOME}/.ssh"

# If there's a bootstrap script, run it once per container start (idempotent)
if [[ -x /opt/toolkit/scripts/bootstrap.sh ]]; then
  /opt/toolkit/scripts/bootstrap.sh || true
fi

echo "Welcome to the DevOps Toolbox container."
echo "Home: ${HOME}  |  Workspace: $(pwd)"
echo "Tip: source /opt/toolkit/scripts/common.sh to load helpers."
exec "$@"
