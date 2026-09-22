#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f -n "${BASH_SOURCE[0]}")")" && pwd)"

source "$SCRIPT_DIR/collector/host.sh"
source "$SCRIPT_DIR/collector/process.sh"



function capture() {

  if [[ ! -d "/proc/$1" ]]; then
    printf "PID  %s is nolonger running\n" "$1"
    exit 1
  fi
  process_fds $1
}
