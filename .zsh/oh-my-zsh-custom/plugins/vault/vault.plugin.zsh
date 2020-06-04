function {
    local vault=$(command -v vault)
    if [[ -n $vault ]] ; then
        autoload -U +X bashcompinit && bashcompinit
        complete -o nospace -C $vault vault
    fi
}
