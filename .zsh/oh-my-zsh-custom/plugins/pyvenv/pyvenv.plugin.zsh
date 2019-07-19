# Disables prompt mangling in virtual_env/bin/activate.
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Prompt function for powerlevel9k.
function prompt_pyvenv {
    [[ -n ${VIRTUAL_ENV} ]] || return

    local prompt=$'\uF01C '

    # If PYVENV_WORKDIR is not set add virtualenv name to prompt.
    if [[ -z $PYVENV_WORKDIR ]] ; then
        local name=${VIRTUAL_ENV:t} # basename
        # Instead of showing '.venv' as name of virtualenv show parent dir name.
        if [[ $name = .venv ]] ; then
            name=${VIRTUAL_ENV:h:t} # dirname . basename
        fi
        prompt+=$name
    fi

    "$1_prompt_segment" "$0" "$2" "blue" "$DEFAULT_COLOR" 'PYTHON_ICON' 0 '' "$prompt"
}

# Activate or deactivate virtualenv depending on current working directory or
# git repository root. If {.venv,venv} directory exists virtualenv is activated
# otherwise deactivated.
function workon_cwd {
    local project_root=${PWD:A}

    local git_repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
    if [[ -n $git_repo_root ]] ; then
        project_root=$git_repo_root
    fi

    local pyvenv_path=$project_root/.venv
    if [[ -d $pyvenv_path ]] ; then
        echo "Activating Python venv '$pyvenv_path'"
        source $pyvenv_path/bin/activate && export PYVENV_WORKDIR=$project_root
    elif [[ -n $VIRTUAL_ENV && -n $PYVENV_WORKDIR ]] ; then
        echo "Deactivating Python venv '$VIRTUAL_ENV'"
        deactivate && unset PYVENV_WORKDIR
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
