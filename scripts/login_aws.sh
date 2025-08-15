#!/usr/bin/env bash
# Authenticate AWS either via SSO or static keys. Creates/updates ~/.aws config.
set -euo pipefail
source /opt/toolkit/scripts/common.sh

PROFILE="${AWS_PROFILE:-default}"
REGION="${AWS_DEFAULT_REGION:-us-east-1}"

mkdir -p "${HOME}/.aws"

if [[ -n "${AWS_SSO_START_URL:-}" ]]; then
  need aws
  aws configure set sso_start_url "${AWS_SSO_START_URL}" --profile "${PROFILE}"
  aws configure set sso_region "${AWS_SSO_REGION:-${REGION}}" --profile "${PROFILE}"
  aws configure set region "${REGION}" --profile "${PROFILE}"
  [[ -n "${AWS_ACCOUNT_ID:-}" ]] && aws configure set sso_account_id "${AWS_ACCOUNT_ID}" --profile "${PROFILE}"
  [[ -n "${AWS_ROLE_NAME:-}" ]] && aws configure set sso_role_name "${AWS_ROLE_NAME}" --profile "${PROFILE}"
  echo "Starting SSO login..."
  aws sso login --profile "${PROFILE}"
  _green "AWS SSO login complete for profile ${PROFILE}."
elif [[ -n "${AWS_ACCESS_KEY_ID:-}" && -n "${AWS_SECRET_ACCESS_KEY:-}" ]]; then
  need aws
  aws configure set aws_access_key_id "${AWS_ACCESS_KEY_ID}" --profile "${PROFILE}"
  aws configure set aws_secret_access_key "${AWS_SECRET_ACCESS_KEY}" --profile "${PROFILE}"
  aws configure set region "${REGION}" --profile "${PROFILE}"
  [[ -n "${AWS_SESSION_TOKEN:-}" ]] && aws configure set aws_session_token "${AWS_SESSION_TOKEN}" --profile "${PROFILE}"
  _green "Configured static AWS credentials for profile ${PROFILE}."
else
  _red "No AWS auth env provided. Set SSO vars (AWS_SSO_START_URL, AWS_SSO_REGION, AWS_ACCOUNT_ID, AWS_ROLE_NAME) or static keys (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)."
  exit 1
fi
