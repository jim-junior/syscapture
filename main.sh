#!/usr/bin/env bash

set -euo pipefail


if [ ! "$#" -gt 3 ]; then
  echo "Error: Missing arguments"
  echo
  echo "Usage: $0 <command> [...PIDS|SYSTEMD_UNIT]"
  exit 1
fi

