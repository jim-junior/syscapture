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

if [ ! "$#" -ge 2 ]; then
  argument_error "missing arguments"
fi


case "$1" in
  "capture")
    capture $2
    ;;
  "watch")
    echo "Watching..."
    sleep 10
    ;;
  *)
    argument_error "unkown argument \`$1\`"
    ;;
esac


