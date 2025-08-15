#!/usr/bin/env bash
# Configure Terraform Cloud credentials and plugin cache
set -euo pipefail
source /opt/toolkit/scripts/common.sh

mkdir -p "${HOME}/.terraform.d/plugin-cache"
if [[ -n "${TERRAFORM_CLOUD_TOKEN:-}" ]]; then
  mkdir -p "${HOME}/.terraform.d"
  cat > "${HOME}/.terraform.d/credentials.tfrc.json" <<EOF
{
  "credentials": {
    "app.terraform.io": {
      "token": "${TERRAFORM_CLOUD_TOKEN}"
    }
  }
}
EOF
  _green "Terraform Cloud token configured."
fi

export TF_PLUGIN_CACHE_DIR="${HOME}/.terraform.d/plugin-cache"
_green "TF_PLUGIN_CACHE_DIR is ${TF_PLUGIN_CACHE_DIR}"
