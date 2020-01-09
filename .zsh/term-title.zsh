# Inspired by oh-my-zsh/lib/termsupport.zsh

# Runs before showing the prompt
function term_title_precmd {
    emulate -L zsh

    # %3~ = 3 trailing components of path
    local tab_title="zsh:%15<..<%3~%<<" #15 char left truncated PWD
    local win_title="zsh:%3~"

    title $tab_title $win_title
}

autoload -U add-zsh-hook
add-zsh-hook precmd term_title_precmd
