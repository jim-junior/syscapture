#!/usr/bin/env bash

set -euo pipefail


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

