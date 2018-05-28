#!/bin/bash

if [[ $# -eq 0 ]] ; then
    tmux ls -F '#S'
else
    mate-terminal -e "tmux -2 a -t '$1'" &>/dev/null &
fi
