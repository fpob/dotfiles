function cheat-widget {
    [[ -z $BUFFER ]] && return
    local cmd=${BUFFER%% *}
    zle push-line
    BUFFER="cheat $cmd"
    zle accept-line
}
zle -N cheat-widget
bindkey "\eh" cheat-widget
