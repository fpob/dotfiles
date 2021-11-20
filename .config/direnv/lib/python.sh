layout_python() {
    local python=${1:-python3}
    shift

    unset PYTHONHOME
    VIRTUAL_ENV=$(direnv_layout_dir)/$python

    local ve=$($python -c "import pkgutil as p; print('venv' if p.find_loader('venv') else ('virtualenv' if p.find_loader('virtualenv') else ''))")
    if [[ -z $ve ]] ; then
        log_error "Neither 'venv' nor 'virtualenv' are available."
        return 1
    fi

    if [[ ! -d $VIRTUAL_ENV ]]; then
        $python -m $ve "$@" "$VIRTUAL_ENV"
    fi

    export VIRTUAL_ENV
    PATH_add "$VIRTUAL_ENV/bin"
}

use_ipdb() {
    export PYTHONBREAKPOINT=ipdb.set_trace
}
