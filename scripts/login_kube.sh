#!/usr/bin/env bash
# Configure kubectl using a provided kubeconfig or helper login
set -euo pipefail
source /opt/toolkit/scripts/common.sh

mkdir -p "${HOME}/.kube"
if [[ -n "${KUBECONFIG_SRC:-}" && -f "${KUBECONFIG_SRC}" ]]; then
  cp "${KUBECONFIG_SRC}" "${HOME}/.kube/config"
  chmod 600 "${HOME}/.kube/config"
  _green "kubeconfig installed to ${HOME}/.kube/config"
elif [[ -n "${GKE_CLUSTER:-}" && -n "${GKE_ZONE:-}" && -n "${GCLOUD_PROJECT:-}" ]]; then
  need gcloud
  gcloud container clusters get-credentials "${GKE_CLUSTER}" --zone "${GKE_ZONE}" --project "${GCLOUD_PROJECT}"
  _green "Configured kubectl from GKE cluster ${GKE_CLUSTER}."
else
  _red "Provide KUBECONFIG_SRC file path, or set GKE_CLUSTER, GKE_ZONE, GCLOUD_PROJECT for GKE."
  exit 1
fi
