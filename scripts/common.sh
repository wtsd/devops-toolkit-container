#!/usr/bin/env bash
# Common helpers and env loader
set -euo pipefail

# Load workspace .env if present
if [[ -f /workspace/.env ]]; then
  export $(grep -v '^#' /workspace/.env | sed 's/#.*//' | xargs) || true
fi

# Colors
_red(){ printf "\033[0;31m%s\033[0m\n" "$*"; }
_green(){ printf "\033[0;32m%s\033[0m\n" "$*"; }
_blue(){ printf "\033[0;34m%s\033[0m\n" "$*"; }

# Check tool presence
need() {
  command -v "$1" >/dev/null 2>&1 || { echo "Required tool '$1' not found in PATH"; exit 1; }
}
