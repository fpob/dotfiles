#!/usr/bin/env bash

# If tmux server not running do nothing
tmux ls &>/dev/null || exit

# Older than 7 days
#find "$HOME/.tmux/environments" -type f -mtime +6 -delete

# Keep only last 10 environments
find "$HOME/.tmux/environments" -type f | sort -rn | tail -n +11 | xargs rm -rf
