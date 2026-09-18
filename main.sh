#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd $(dirname $(readlink -f -n "${BASH_SOURCE[0]}")) && pwd)"

source "${SCRIPT_DIR}/lib/main.sh"



function argument_error() {
  echo "Error: $1"
  echo
  echo "Usage: $0 <command> [...PIDS|SYSTEMD_UNIT]"
  exit 1
}

if [ ! "$#" -ge 3 ]; then
  argument_error "missing arguments"
fi


if [[ ! "$1" =~ ^(capture|doctor|watch)$ ]]; then
  argument_error "unknown argument  \`$1\`"
fi

