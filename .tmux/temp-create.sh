#!/usr/bin/env bash

#
# Script to start tmux with temporary session that will not survive detach. Used
# as "Custom command" in terminal emulator.
#

TEMP_TMUX_SESSION=temp-$$

# Kills session when parent process (terminal) is closed or session is detached.
trap 'tmux kill-session -t $TEMP_TMUX_SESSION' EXIT

tmux new -As $TEMP_TMUX_SESSION
