#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd $(dirname $(readlink -f -n "${BASH_SOURCE[0]}")) && pwd)"

source "${SCRIPT_DIR}/lib/main.sh"



function argument_error() {
  echo "Error: $1"
  echo
  echo "Usage: $0 <command> pid=[...PIDS] unit=[SYSTEMD_UNIT] out=[FILE]"
  exit 1
}

if [ ! "$#" -ge 1 ]; then
  argument_error "missing arguments"
fi


# extract params

pid=
outfile=

for arg in "$@"; do
  if [[ "$arg" =~ ^pid=.+ ]]; then
    pid="${arg#pid=}"
    echo "PID: $pid"
  elif [[ "$arg" =~ ^out=.+ ]]; then
    outfile="${arg#out=}"
  fi
done




case "$1" in
  "capture")

    if [[ -z "$pid" ]]; then
      read -r -p "Enter process PID: " pid
      if [[ -z "$pid" ]]; then
        echo "Error: No process was provided"
        exit 1
      fi
    fi

    if [[ -z "$outfile" ]]; then
      capture $pid
    else
      touch -m "$outfile"
      capture $pid >> "$outfile"
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


