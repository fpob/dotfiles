#!/bin/sh

DIR=$(dirname "$0")

# https://github.com/brndnmtthws/conky/issues/20
export LANG=en_US.UTF-8
# Send the header so that i3bar knows we want to use JSON:
echo '{"version":1}'
# Begin the endless array.
echo '['
# We send an empty first array of blocks to make the loop simpler:
echo '[],'
# Now send blocks with information forever:
exec conky -c "$DIR/conky.conf"
