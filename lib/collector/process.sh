#!/usr/bin/env bash

function process_fd_count() {
  local FD_COUNT=$(ls -l "/proc/$1/fd" | wc -l) 

  echo "Process $1 has $((FD_COUNT - 1)) Open File descriptors, this includes the standard streams"
}

function process_fds() {
  local FD_LIST=$(ls -l "/proc/$1/fd" | awk '{print $9}')

  printf "### Open File list \n\n"

  process_fd_count $1

  printf "This is the list of open files the process is trying to access\n\n"
  echo "| File Descriptor | File Location | File Deleted |"
  echo "|-----------------|---------------|--------------|"

  for fd in $FD_LIST; do
    if [[ $fd =~ ^(0|1|2)$ ]]; then
      continue
    fi
    local LINK=$(readlink -f -n "/proc/$1/fd/$fd")
    if [[ $LINK == *" (deleted)" ]]; then
      deleted="YES"
      symlink="${LINK% (deleted)}"
    else
      deleted="NO"
      symlink="$LINK"
    fi
    echo "| $fd  | \`$symlink\` | $deleted |"
  done;

}
