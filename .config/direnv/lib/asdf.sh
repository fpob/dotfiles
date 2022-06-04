use_asdf () {
    . "$ASDF_DIR/asdf.sh"

    if [[ $# -ge 1 ]] ; then
        asdf shell "$1" "${2:-latest}"
    fi
}
