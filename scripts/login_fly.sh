#!/usr/bin/env bash
# Login to Concourse via fly
set -euo pipefail
source /opt/toolkit/scripts/common.sh

need fly

: "${FLY_TARGET:=ci}"
: "${FLY_URL:?Set FLY_URL to your Concourse URL}"
: "${FLY_TEAM:=main}"

if [[ -n "${FLY_USERNAME:-}" && -n "${FLY_PASSWORD:-}" ]]; then
  fly -t "${FLY_TARGET}" login -c "${FLY_URL}" -n "${FLY_TEAM}" -u "${FLY_USERNAME}" -p "${FLY_PASSWORD}"
elif [[ -n "${FLY_TOKEN:-}" ]]; then
  fly -t "${FLY_TARGET}" login -c "${FLY_URL}" -n "${FLY_TEAM}" -b "${FLY_TOKEN}"
else
  _blue "No creds provided; launching interactive login..."
  fly -t "${FLY_TARGET}" login -c "${FLY_URL}" -n "${FLY_TEAM}"
fi
_green "fly target '${FLY_TARGET}' configured."
