_python_version() {
    "$1" -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")' 2>/dev/null
}

_python_base_prefix() {
    "$1" -c 'import sys, os; print(os.path.realpath(sys.base_prefix))' 2>/dev/null
}

layout_python() {
    local python=${1:-python3}
    shift

    local python_version=$(_python_version "$python")
    if [[ -z $python_version ]] ; then
        log_error "Could not determine Python version."
        return 1
    fi

    unset PYTHONHOME
    VIRTUAL_ENV=$(direnv_layout_dir)/python$python_version

    # If venv exists, check if symlinks are pointing to the selected python, if
    # not delete them, venv command will re-create them.
    if [[ -e $VIRTUAL_ENV \
            && $(_python_base_prefix "$VIRTUAL_ENV/bin/python") \
            != $(_python_base_prefix "$python")
    ]] ; then
        find "$VIRTUAL_ENV/bin" -name 'python*' -type l -delete
    fi

    if [[ ! -e $VIRTUAL_ENV/bin/python ]]; then
        $python -m venv "$@" "$VIRTUAL_ENV"
    fi

    export VIRTUAL_ENV
    PATH_add "$VIRTUAL_ENV/bin"
}

layout_poetry() {
    export POETRY_VIRTUALENVS_PATH=$(direnv_layout_dir)/poetry
    mkdir -p "$POETRY_VIRTUALENVS_PATH"

    poetry env use "${1:-python3}"
    direnv_load poetry run direnv dump
}
