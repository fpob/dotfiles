# Execute only in Kitty terminal.
if [[ $TERM != xterm-kitty ]] ; then return ; fi

function icat {
    kitty +kitten icat $@
}

function kitty-diff {
    kitty +kitten diff $@
}

function clipboard {
    kitty +kitten clipboard $@
}

completion_file="$ZSH_CACHE_DIR/completions/_kitty"
if [[ ! -f "$completion_file" ]] ; then
    kitty + complete setup zsh > "$completion_file"
fi
unset completion_file
