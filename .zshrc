# Term ---------------------------------------------------------------------{{{1

case $TERM in
    xterm*) export TERM="xterm-256color" ;;
esac

# Tmux ---------------------------------------------------------------------{{{1

if [[ $(id -u) -ge 1000 ]] ; then
    # If not in tmux and not in mc subshell and connected via SSH
    if [[ -z $TMUX && -z $MC_SID && -n $SSH_CONNECTION ]] ; then
        # If session "main" exists then attach otherwise create
        tmux -2 new -A -s main
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

# Default less options
export LESS=-RK

# https://stackoverflow.com/questions/51504367
export GPG_TTY=$(tty)

# Paths --------------------------------------------------------------------{{{1

# Bin path
path=(~/.bin ~/.local/bin $GOPATH/bin $path)
typeset -gU path

# Man path
MANPATH=$(env MANPATH= manpath)
manpath=(~/.local/man $manpath)
typeset -gU manpath

# Oh My Zsh / load .zsh ----------------------------------------------------{{{1

ZSH_D=$HOME/.zsh

# OMZ paths
ZSH=$ZSH_D/oh-my-zsh
ZSH_CUSTOM=$ZSH_D/oh-my-zsh-custom

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
    pyvenv
    ranger
    redis-cli
    sudo
    taskwarrior
    transfer
    zsh_reload
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Remove all aliases from OMZ plugins
unalias -m '*'

# Add a function path
fpath=($ZSH_D/functions $ZSH_D/completions $fpath)
# reload completion functions
autoload -Uz compinit && compinit

# Load all custom config files
for config_file ($ZSH_D/*.zsh(N)) ; do
    source $config_file
done
unset config_file

# Load run-help function
autoload -Uz run-help

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

# Aliasses -----------------------------------------------------------------{{{1

# Sudo with alias expansion, see aliases section in man bash
alias sudo_='sudo '

alias e='$EDITOR'
alias f='$FILE_MANAGER'

alias ls="ls -v --color=auto"
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

alias grep="grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}"
alias ggrep='git ls-files -co --exclude-standard -z | xargs -0 grep --color=auto -nT'

# Python3
alias py='python3'
alias pyc='py3compile'
alias pydoc='pydoc3'
alias pyvenv='python3 -m venv'
alias ipy='ipython3'

# force 256 colors
alias tmux='tmux -2'

# Copy & Paste Clipboard
alias ci='xsel -ib'
alias co='xsel -ob'

# Curl with kerberos auth
alias kcurl='curl -u : --negotiate'
# JSON Curl
alias jcurl='curl -H "Accept: application/json" -H "Content-type: application/json"'

# Syntax highlight
alias syn='pygmentize -f 256 -O bg=dark,style=monokai'
# Markdown viewer
alias mdv='mdv -t 884.0134 -c $(tput cols) -u i'

# Cut long lines
alias cll='cut -c -$COLUMNS'
# Format CSV/TSV as table (aligned)
alias csv="column -t -s,"
alias tsv="column -t -s$'\t'"

alias gdb='gdb -q'
alias bc='bc -ql'
alias octave='octave -qW'

# Global aliasses
alias -g L='|less -FX'
alias -g LL='2>&1|less -FX'
alias -g G='|grep -Pi'
alias -g T='|tail'
alias -g H='|head'
alias -g N='&>/dev/null'

# Suffix aliasess
alias -s py='python3'
alias -s sh='bash'
alias -s zsh='zsh'
alias -s awk='awk -f'

# Color man pages ----------------------------------------------------------{{{1

export LESS_TERMCAP_mb=$'\E[41m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;31m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[04;34m'
