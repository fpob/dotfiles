function ranger-cd {
    local tempfile="$(mktemp -t ranger.XXXXXX)"
    ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    [[ -f "$tempfile" ]] && cd -- "$(cat $tempfile)"
    rm -f -- "$tempfile"
}

function ranger-cd-widget {
    ranger-cd </dev/tty >/dev/tty

    local fn
    for fn (chpwd $chpwd_functions precmd $precmd_functions); do
        (( $+functions[$fn] )) && $fn
    done
    zle reset-prompt
}
zle -N ranger-cd-widget

# ranger-cd will fire for Ctrl+O
[[ $RANGER_LEVEL -eq 0 ]] && bindkey '^O' ranger-cd-widget
