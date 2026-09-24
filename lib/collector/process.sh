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

function process_stats() {

  if command -v ps &> /dev/null; then
    ps_process_stats $1
  else
    proc_process_stats $1
  fi

}


function ps_process_stats() {

  ps_stats=$(ps -o state,ppid,wchan,cmd --pid "$1")

  process_state=$(awk 'NR==2 {print $1}' <<< "$ps_stats")
  process_ppid=$(awk 'NR==2 {print $2}' <<< "$ps_stats")
  process_wchan=$(awk 'NR==2 {print $3}' <<< "$ps_stats")
  process_cmd=$(awk 'NR==2 {print $4}' <<< "$ps_stats")

  printf "Process runtime stats\n\n"
  echo "- State: $process_state"
  echo "- Parent Process PID: $process_ppid"
  echo "- Wait Channel: $process_wchan"
  echo "- Program Command: \`$process_cmd\`"

  printf "\n"

}


function proc_process_stats() {

  proc_status_file=$(cat "/proc/$1/status")
  process_cmd=$(cat "/proc/$1/cmdline")
  process_wchan=$(cat "/proc/$1/wchan")
  process_state=$(grep "State" <<< "$proc_status_file")
  process_state="${process_state#State:}"
  process_ppid=$(grep "PPid" <<< "$proc_status_file")
  process_ppid="${process_ppid#PPid:}"

  printf "Process runtime stats\n\n"
  echo "- State: $process_state"
  echo "- Parent Process PID: $process_ppid"
  echo "- Wait Channel: $process_wchan"
  echo "- Program Command: \`$process_cmd\`"

}




function process_memory_stats() {

  proc_rss=$(cat "/proc/$1/smaps_rollup" | grep "Rss")
  rss="${proc_rss#Rss:}"

  proc_pss_line=$(cat "/proc/$1/smaps_rollup" | grep "Pss: ")
  pss="${proc_pss_line#Pss:}"


}
