layout_python() {
    local python="${2:-python3}"
    shift

    # Resolve '$python' to its real path/name, in case it is symlink.
    local python_path="$(realpath "$(which "$python")")"
    if [[ -z "$python_path" ]]; then
        log_error "Python '$python' not found in PATH"
        return 1
    fi

    python="$(basename "$python_path")"

    unset PYTHONHOME
    VIRTUAL_ENV="$(direnv_layout_dir)/$python"

    local ve="$("$python" -c "import pkgutil as p; print('venv' if p.find_loader('venv') else ('virtualenv' if p.find_loader('virtualenv') else ''))")"
    if [[ -z "$ve" ]] ; then
        log_error "Neither 'venv' nor 'virtualenv' are available."
        return 1
    fi

    if [[ ! -d "$VIRTUAL_ENV" ]]; then
        "$python" -m "$ve" "$@" "$VIRTUAL_ENV"
    fi

    export VIRTUAL_ENV
    PATH_add "$VIRTUAL_ENV/bin"
}

use_ipdb() {
    export PYTHONBREAKPOINT=ipdb.set_trace
}
