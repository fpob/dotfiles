function ranger-cd {
    local tempfile="$(mktemp -t ranger.XXXXXX)"
    ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    [[ -f "$tempfile" ]] && cd -- "$(cat $tempfile)"
    rm -f -- "$tempfile"
}

# ranger-cd will fire for Ctrl+O
bindkey -s '^O' 'ranger-cd\n'
