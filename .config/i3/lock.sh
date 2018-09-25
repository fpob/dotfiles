#!/bin/sh

IMAGE=/tmp/i3lock.png
trap 'rm -f $IMAGE' EXIT

# Suspend message display.
pkill -u "$USER" -USR1 dunst

# Capture screen and apply blur effect.
scrot $IMAGE
convert $IMAGE -filter Gaussian -resize 20% -define 'filter:sigma=1.5' -resize 500.5% $IMAGE

# Nofork option (-n) is required because of following commands!
i3lock -c 000000 -ti $IMAGE -n

# Resume message display.
pkill -u "$USER" -USR2 dunst
