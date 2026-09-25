#!/usr/bin/env bash

function host_momory() {

  free_h_output=$(free -h)
  total_mem=$(awk 'NR==2 {print $2}' <<< $free_h_output)
  available_mem=$(awk 'NR==2 {print $7}' <<< $free_h_output)
  used_mem=$(awk 'NR==2 {print $3}' <<< $free_h_output)
  total_swap=$(awk 'NR==3 {print $2}' <<< $free_h_output)
  used_swap=$(awk 'NR==3 {print $3}' <<< $free_h_output)
  free_swap=$(awk 'NR==3 {print $4}' <<< $free_h_output)


  cat << EOF
| Type | Total | Used | Available / Free |
| :--- | :--- | :--- | :--- |
| **RAM** | $total_mem | $used_mem | $available_mem |
| **Swap** | $total_swap | $used_swap | $free_swap |
EOF


}

