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

if [ ! "$#" -ge 1 ]; then
  argument_error "missing arguments"
fi


case "$1" in
  "capture")
    if [[ ! "$#" -lt 2 ]]; then
      capture $2
    else
      read -r -p "Enter process PID: " pid
      if [[ -n pid ]]; then
        echo "Error: No process was provided"
        exit 1
      fi

      capture $pid
    fi
    ;;
  "watch")
    echo "Watching..."
    sleep 10
    ;;
  *)
    argument_error "unkown argument \`$1\`"
    ;;
esac


