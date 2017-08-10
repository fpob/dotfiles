#!/bin/sh

IMAGE=/tmp/i3lock.png

scrot $IMAGE
convert $IMAGE -filter Gaussian -resize 20% -define 'filter:sigma=1.5' -resize 500.5% $IMAGE
i3lock -i $IMAGE
