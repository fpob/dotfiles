#!/usr/bin/env bash

# If tmux server not running do nothing
tmux ls &>/dev/null || exit

# Keep only last 50 environments
find "$HOME/.tmux/environments" -type f | sort -r | tail -n +51 | xargs rm

# Fix broken link
if [[ ! -f "$HOME/.tmux/environments/last" ]] ; then
    last=$(find "$HOME/.tmux/environments" -type f | sort | tail -n 1)
    ln -sf "$last" "$HOME/.tmux/environments/last"
fi
