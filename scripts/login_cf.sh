#!/usr/bin/env bash
# Login to Cloud Foundry (cf CLI v8)
set -euo pipefail
source /opt/toolkit/scripts/common.sh

need cf || need cf8

: "${CF_API:?Set CF_API to your Cloud Foundry API endpoint (e.g., https://api.example.com)}"
CF_ORG="${CF_ORG:-}"
CF_SPACE="${CF_SPACE:-}"

if [[ -n "${CF_USERNAME:-}" && -n "${CF_PASSWORD:-}" ]]; then
  cf login -a "$CF_API" -u "$CF_USERNAME" -p "$CF_PASSWORD" ${CF_ORG:+-o "$CF_ORG"} ${CF_SPACE:+-s "$CF_SPACE"}
elif [[ -n "${CF_SSO_PASSCODE:-}" ]]; then
  cf login -a "$CF_API" --sso-passcode "$CF_SSO_PASSCODE" ${CF_ORG:+-o "$CF_ORG"} ${CF_SPACE:+-s "$CF_SPACE"}
else
  _red "Provide CF_USERNAME/CF_PASSWORD or CF_SSO_PASSCODE along with CF_API."
  exit 1
fi
_green "CF login completed."
