#!/usr/bin/env bash

cd $HOME/.tmux/environments
last=$(basename "$(find "$HOME/.tmux/environments" -type f | sort -n | tail -n 1)")
ln -sf "$last" last
