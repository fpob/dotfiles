if (( $+commands[kubectl] )); then
    completion_file="$ZSH_CACHE_DIR/completions/_kubectl"
    if [[ ! -f "$completion_file" ]] ; then
        kubectl completion zsh > "$completion_file"
    fi
    unset completion_file
fi
