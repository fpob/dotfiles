function cheat-widget {
    [[ -z $BUFFER ]] && return
    local cmd=${BUFFER%% *}
    zle push-line
    BUFFER="cheat $cmd"
    zle accept-line
}
zle -N cheat-widget
bindkey "\eh" cheat-widget

function _cheat {
    reply=($(cheat -l | cut -d' ' -f1))
}
compctl -K _cheat cheat
