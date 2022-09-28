layout_python() {
    local python="${1:-python3}"
    shift

    # Resolve '$python' to its real path, in case it is symlink.
    local python_path="$(realpath "$(which "$python")" 2>/dev/null)"
    if [[ -z "$python_path" ]]; then
        log_error "Python '$python' not found in PATH"
        return 1
    fi

    unset PYTHONHOME
    VIRTUAL_ENV="$(direnv_layout_dir)/$(basename "$python_path")"

    local ve="$("$python_path" -c "import pkgutil as p; print('venv' if p.find_loader('venv') else ('virtualenv' if p.find_loader('virtualenv') else ''))")"
    if [[ -z "$ve" ]] ; then
        log_error "Neither 'venv' nor 'virtualenv' are available."
        return 1
    fi

    if [[ ! -d "$VIRTUAL_ENV" ]]; then
        "$python_path" -m "$ve" "$@" "$VIRTUAL_ENV"
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
