#!/usr/bin/env bash
# Authenticate to Google Cloud via service account key or user login
set -euo pipefail
source /opt/toolkit/scripts/common.sh

need gcloud

if [[ -n "${GOOGLE_APPLICATION_CREDENTIALS:-}" && -f "${GOOGLE_APPLICATION_CREDENTIALS}" ]]; then
  gcloud auth activate-service-account --key-file="${GOOGLE_APPLICATION_CREDENTIALS}"
  [[ -n "${GCLOUD_PROJECT:-}" ]] && gcloud config set project "${GCLOUD_PROJECT}"
  _green "Activated service account and set project ${GCLOUD_PROJECT:-<not set>}."
else
  _blue "No GOOGLE_APPLICATION_CREDENTIALS found. Falling back to user login..."
  gcloud auth login --update-adc
  [[ -n "${GCLOUD_PROJECT:-}" ]] && gcloud config set project "${GCLOUD_PROJECT}"
fi
