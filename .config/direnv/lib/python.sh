layout_python() {
    local python="${1:-python3}"
    shift

    local python_version=$($python -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
    if [[ -z "$python_version" ]] ; then
        log_error "Could not determine Python version."
        return 1
    fi

    unset PYTHONHOME
    VIRTUAL_ENV="$(direnv_layout_dir)/python$python_version"

    if [[ ! -d "$VIRTUAL_ENV" ]]; then
        "$python" -m venv "$@" "$VIRTUAL_ENV"
    fi

    export VIRTUAL_ENV
    PATH_add "$VIRTUAL_ENV/bin"
}

use_ipdb() {
    local python=python3
    if [[ -n "$VIRTUAL_ENV" ]] ; then
        python="$VIRTUAL_ENV/bin/python"
    fi

    if ! "$python" -c "import ipdb" &> /dev/null ; then
        log_error "'ipdb' is not installed."
    fi

    export PYTHONBREAKPOINT=ipdb.set_trace
}
