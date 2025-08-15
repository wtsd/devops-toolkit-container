#!/usr/bin/env bash
# Authenticate to Vault using VAULT_TOKEN or AppRole credentials
set -euo pipefail
source /opt/toolkit/scripts/common.sh

need vault

: "${VAULT_ADDR:?Set VAULT_ADDR to your Vault URL}"

if [[ -n "${VAULT_TOKEN:-}" ]]; then
  echo -n "${VAULT_TOKEN}" > "${HOME}/.vault-token"
  _green "Vault token written to ${HOME}/.vault-token"
elif [[ -n "${VAULT_ROLE_ID:-}" && -n "${VAULT_SECRET_ID:-}" ]]; then
  LOGIN_JSON=$(jq -n --arg role_id "$VAULT_ROLE_ID" --arg secret_id "$VAULT_SECRET_ID" '{role_id:$role_id, secret_id:$secret_id}')
  TOKEN=$(curl -sSf -X POST "${VAULT_ADDR%/}/v1/auth/approle/login" -H "Content-Type: application/json" -d "${LOGIN_JSON}" | jq -r .auth.client_token)
  [[ -z "$TOKEN" || "$TOKEN" == "null" ]] && { echo "Failed to obtain Vault token"; exit 1; }
  echo -n "$TOKEN" > "${HOME}/.vault-token"
  _green "Logged into Vault via AppRole."
else
  _red "Provide VAULT_TOKEN or VAULT_ROLE_ID + VAULT_SECRET_ID"
  exit 1
fi
