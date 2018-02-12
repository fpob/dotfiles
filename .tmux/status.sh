#!/bin/bash

# PID of client process
declare -r client_pid=$1
# PID of first process in pane
declare -r pane_pid=$2

# Load environment from client process
# https://unix.stackexchange.com/questions/125110/how-do-i-source-another-processs-environment-variables
if [[ -n $client_pid ]] ; then
    # PWD is used as a temporary variable name to avoid clobbering another variable
    # that might end up being imported.
    while IFS= read -r -d "" PWD; do export "$PWD"; done </proc/$client_pid/environ
    PWD=$(pwd)
fi

# Disable locale settings (wrong decimal pont etc.)
export LANG=C

read load1 load5 load15 _ </proc/loadavg
# top appears to give incorrect CPU usage on first iteration
read cpu mem < <(top -b -n2 -d0.1 | awk '/^%Cpu/ { cpu = $2 + $4 } /^KiB Mem/ { mem = $8 / $4 * 100 } END { print cpu, mem }')

printf '\uf0e4 %.0f%% \uf080 %.2f \uf2db %.0f%%' $cpu $load1 $mem

#printf ' \ue0b3 '

[[ -n $SSH_CONNECTION ]] && printf ' \ue0b3 #[bold]%s#[nobold]' 'SSH'
