#!/bin/bash

if [[ $# -eq 0 ]] ; then
    tmux ls -F '#S'
else
    kitty tmux -2 a -t "$1" &>/dev/null &
fi
