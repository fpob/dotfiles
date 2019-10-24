# Disables prompt mangling in virtual_env/bin/activate.
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Prompt function for powerlevel9k.
function prompt_pyvenv {
    [[ -n ${VIRTUAL_ENV} ]] || return

    local icon=$'\uF01C'
    local text=

    # If PYVENV_WORKDIR is not set add virtualenv name to prompt.
    if [[ -z $PYVENV_WORKDIR ]] ; then
        text=${VIRTUAL_ENV:t} # basename
        # Instead of showing '.venv' as name of virtualenv show parent dir name.
        if [[ $name = .venv ]] ; then
            text=${VIRTUAL_ENV:h:t} # dirname . basename
        fi
    fi

    p10k segment -f blue -i "$icon" -t "$text"
}

# Activate or deactivate virtualenv depending on current working directory or
# git repository root. If {.venv,venv} directory exists virtualenv is activated
# otherwise deactivated.
function workon_cwd {
    local project_root=$(git rev-parse --show-toplevel 2>/dev/null)

    # Try to find venv in parent directory.
    if [[ -z $project_root ]] ; then
        project_root=${PWD:A}
        while [[ ${#project_root} -gt 1 && ! -d $project_root/.venv ]] ; do
            project_root=${project_root:h}
        done
    fi

    local pyvenv_path=$project_root/.venv
    if [[ -d $pyvenv_path ]] ; then
        if [[ -z $VIRTUAL_ENV ]] ; then
            echo "Activating Python venv '$pyvenv_path'"
            source $pyvenv_path/bin/activate && export PYVENV_WORKDIR=$project_root
        fi
    elif [[ -n $VIRTUAL_ENV && -n $PYVENV_WORKDIR ]] ; then
        echo "Deactivating Python venv '$VIRTUAL_ENV'"
        deactivate && unset PYVENV_WORKDIR
    else
        return 1
    fi
}

function workon {
    if [[ -z $1 ]] ; then
        workon_cwd || echo "Virtualenv not found in current or parent directories"
    else
        if [[ -f $1/pyvenv.cfg ]] ; then
            source "$1/bin/activate"
        else
            source "$1/.venv/bin/activate"
        fi
    fi
}

if [[ $PYVENV_DISABLE_CD -ne 1 ]]; then
    if ! (( $chpwd_functions[(I)workon_cwd] )); then
        chpwd_functions+=(workon_cwd)
    fi
    # Try automaticaly activate virtualenv. chpwd_functions are not triggered
    # when shell is started with already changed PWD (tmux splits, ...).
    workon_cwd
fi
