#!/usr/bin/env bash

#
# Clean temporaray sessions that was detached but not removed for some reason.
# See also 'temp-create.sh' script.
#

tmux ls -F '#{session_name}:#{session_attached}' \
    | awk -F: '$1 ~ /^temp-/ && $2 == "0" { print $1 }' \
    | xargs -r -n1 tmux kill-session -t
