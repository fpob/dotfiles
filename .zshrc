# Term ---------------------------------------------------------------------{{{1

case $TERM in
    xterm*) export TERM="xterm-256color" ;;
esac

# Tmux ---------------------------------------------------------------------{{{1

# If not in tmux and not in mc subshell
if [[ -z $TMUX && -z $MC_SID ]] ; then
    if [[ -n $SSH_CONNECTION ]] ; then
        # If session "main" exists then attach otherwise create
        tmux new -A -s main
    fi
fi

# Variables ----------------------------------------------------------------{{{1

export EDITOR=${EDITOR:-vim}
export FILE_MANAGER=${FILE_MANAGER:-ranger}

# Python startup script
[[ -f $HOME/.pythonrc ]] && export PYTHONSTARTUP=$HOME/.pythonrc

# `ts` environment
export TS_ENV="pwd"

# Python virtualenvwrapper variables
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Projects
export VIRTUALENVWRAPPER_PYTHON=$(which python3)

# golang
export GOPATH=$HOME/.go

# Paths --------------------------------------------------------------------{{{1

# Bin path
path=(~/.bin ~/.local/bin $GOPATH/bin $path)
typeset -gU path

# Man path
MANPATH=$(env MANPATH= manpath)
manpath=(~/.local/man $manpath)
typeset -gU manpath

# Oh My Zsh / zshrc.d ------------------------------------------------------{{{1

ZSHRC_D=$HOME/.zshrc.d

# OMZ paths
ZSH=$ZSHRC_D/oh-my-zsh
ZSH_CUSTOM=$ZSHRC_D/oh-my-zsh-custom

if [[ -n $MC_SID || $TERM = 'linux' ]] ; then
    ZSH_THEME="simple"
else
    ZSH_THEME="powerlevel10k/powerlevel10k"
fi

#CASE_SENSITIVE="true"
DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="false"
COMPLETION_WAITING_DOTS="true"
DISABLE_AUTO_UPDATE="true"
ZLE_REMOVE_SUFFIX_CHARS=""

plugins=(
    autojump
    cheat
    direnv
    docker
    docker-compose
    git
    git-flow
    go
    history-substring-search
    kubectl
    oc
    pip
    python
    ranger
    redis-cli
    sudo
    taskwarrior
    transfer
    virtualenvwrapper
    zsh_reload
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Remove all aliases from OMZ plugins
unalias -m '*'

# Add a function path
fpath=($ZSHRC_D/functions $ZSHRC_D/completions $fpath)
# reload completion functions
autoload -Uz compinit && compinit

# Load all custom config files
for config_file ($ZSHRC_D/*.zsh(N)) ; do
    source $config_file
done
unset config_file

# Load run-help function
autoload -Uz run-help

# Try automaticaly activate virtualenv. chpwd_functions are not triggered when
# shell is started with changed PWD (tmux new split/panel, ...).
[[ ! $DISABLE_VENV_CD -eq 1 ]] && workon_cwd

# History setup ------------------------------------------------------------{{{1
# Has to be done after OMZ setup

export HISTFILE=$HOME/.zsh_history
export HISTSIZE=65536
export SAVEHIST=$HISTSIZE

# Ignore commands that starts with space and duplicates of the prevous command
export HISTCONTROL=ignorespace:ignoredups

# Syntax highlight setup ---------------------------------------------------{{{1
# https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md

ZSH_HIGHLIGHT_STYLES[path]='none'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=245'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=245'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=42'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=42'

# powerlevel9k setup -------------------------------------------------------{{{1

if [[ $ZSH_THEME =~ powerlevel* ]] ; then

# Enable precmd and preexec, without this powerlevel9k will not work properly
autoload -U add-zsh-hook
add-zsh-hook precmd  omz_termsupport_precmd
add-zsh-hook preexec omz_termsupport_preexec

# Rename function `getUniqueFolder` to `original_getUniqueFolder`
eval "original_$(declare -f getUniqueFolder)"

# Shorten path as same as getUniqueFolder does but with expanded last element.
function getUniqueFolder() {
    local trunc_path=$(original_getUniqueFolder "$1")
    if [[ $trunc_path =~ .*/.* ]] ; then
        [[ $1 != $HOME ]] && trunc_path="${trunc_path%/*}/${PWD##*/}"
    else
        # directory one level in root, eg. `mnt`
        trunc_path=${PWD:1}
    fi
    echo $trunc_path
}

# Parent process name
prompt_parent_cache=$(ps -p $PPID -o comm=)
function prompt_parent() {
    case $prompt_parent_cache in
        ranger|vim|nvim) echo $prompt_parent_cache ;;
    esac
}

POWERLEVEL9K_CUSTOM_PARENT="prompt_parent"
POWERLEVEL9K_CUSTOM_PARENT_FOREGROUND="yellow"
POWERLEVEL9K_CUSTOM_PARENT_BACKGROUND="black"

POWERLEVEL9K_STATUS_CROSS=true
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_to_unique"
POWERLEVEL9K_ROOT_ICON="\u2622"

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(root_indicator context dir)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs vcs virtualenv custom_parent ssh)

fi # END powerlevel9k

# Aliasses -----------------------------------------------------------------{{{1

alias e='$EDITOR'
alias f='$FILE_MANAGER'

# Colors
alias ls="ls -v --color=auto"
alias grep="grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}"

# ls shortcuts
alias l='ls -CF'
alias ll='l -hl --time-style="+%Y-%m-%d %H:%M"'
alias la='l -A'
alias lla='ll -A'

# COW copy if available
alias cp='cp --reflink=auto'

# Human readable sizes
alias du='du -khc'
alias df='df -kTh'
alias free='free -th'

# Python3
alias py='python3'
alias pyc='py3compile'
alias pydoc='pydoc3'
alias ipy='ipython3'

# TaskWarrior
alias t='nocorrect task'

# force 256 colors
alias tmux='tmux -2'

# Copy & Paste Clipboard
alias ci='xsel -ib'
alias co='xsel -ob'

# Cut long lines
alias cll='cut -c -$COLUMNS'

# git-grep with external grep
alias ggrep='git ls-files -co --exclude-standard -z | xargs -0 grep --color=auto -nT'

# Curl with kerberos auth
alias kcurl='curl -u : --negotiate'

# Syntax highlight
alias syn='pygmentize -f 256 -O bg=dark,style=monokai'
# Markdown viewer
alias mdv='mdv -t 884.0134 -c $(tput cols) -u i'

alias tsv="column -t -s$'\t'"
alias json="python -mjson.tool"

alias gdb='gdb -q'
alias bc='bc -ql'
alias octave='octave -qW'

# Global aliasses
alias -g L='|less -FKRX'
alias -g LL='2>&1|less -FKRX'
alias -g G='|grep -Pi'
alias -g T='|tail'
alias -g H='|head'
alias -g N='&>/dev/null'

# Color man pages ----------------------------------------------------------{{{1

export LESS_TERMCAP_mb=$'\E[41m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;31m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[04;34m'
