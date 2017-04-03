function ranger {
    command ranger "$@"
    # change title to zsh
    printf '\033kzsh\033\\'
}

function ranger-cd {
    tempfile="$(mktemp -t tmp.XXXXXX)"
    ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}

bindkey -s '^O' 'ranger-cd\n'
#ranger-cd will fire for Ctrl+O
