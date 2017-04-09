function ranger {
    command ranger "$@"
    # change tmux title back to zsh
    [[ -n $TMUX ]] && printf '\033kzsh\033\\'
}

function ranger-cd {
    local tempfile="$(mktemp -t ranger.XXXXXX)"
    ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    [[ -f "$tempfile" ]] && cd -- "$(cat $tempfile)"
    rm -f -- "$tempfile"
}

# ranger-cd will fire for Ctrl+O
bindkey -s '^O' 'ranger-cd\n'
