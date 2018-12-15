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

# Paths --------------------------------------------------------------------{{{1

# Bin path
path=(~/.bin ~/.local/bin ~/.go/bin $path)
typeset -gU path

# Man path
MANPATH=$(env MANPATH= manpath)
manpath=(~/.local/man $manpath)
typeset -gU manpath

# Variables ----------------------------------------------------------------{{{1

# Parent process name
PARENT=$(ps -p $PPID -o comm=)

if [[ -n $SSH_CONNECTION || -n $MC_SID ]]; then
    export BROWSER=${BROWSER:-lynx}
    export EDITOR=${EDITOR:-vim}
else
    export BROWSER=${BROWSER:-firefox}
    export EDITOR=${EDITOR:-vim}
fi

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

# ssh key
#export SSH_KEY_PATH="~/.ssh/dsa_id"

# History
HISTFILE=$HOME/.zsh_history
HISTSIZE=2500
SAVEHIST=5000

# Customize highlighting
# https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]='none'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=245'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=245'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=42'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=42'

# Oh My Zsh ----------------------------------------------------------------{{{1

export ZSH=$HOME/.oh-my-zsh

if [[ -n $MC_SID || $TERM = 'linux' ]] ; then
    ZSH_THEME="simple"
else
    ZSH_THEME="powerlevel9k/powerlevel9k"
fi

# Nastaveni
#CASE_SENSITIVE="true"
DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_AUTO_UPDATE="true"
ZLE_REMOVE_SUFFIX_CHARS=""

# Pluginy
plugins=(sudo zsh_reload git git-flow autojump taskwarrior redis-cli
         python pip virtualenvwrapper docker docker-compose autojump oc go)
# custom
plugins+=(cheat ranger zsh-syntax-highlighting direnv)

# Pridani podpory precmd a preexec, bez toho nefunguje theme powerlevel9k
autoload -U add-zsh-hook
add-zsh-hook precmd  omz_termsupport_precmd
add-zsh-hook preexec omz_termsupport_preexec

source $ZSH/oh-my-zsh.sh

fpath=($ZSH_CUSTOM/completions $ZSH_CUSTOM/functions $fpath)
typeset -Ug fpath

# Reinicializace doplnovani, kvuli vlastnim doplnovani
#autoload -Uz compinit
#compinit -d "$ZSH_CACHE_DIR/zcomp-$HOST"

# Opravy jen u nazvu prikazu, ne vsude
unsetopt correct_all
setopt correct

# Prompt -------------------------------------------------------------------{{{1

if [[ $ZSH_THEME = 'powerlevel9k/powerlevel9k' ]] ; then

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

POWERLEVEL9K_CUSTOM_PARENT="case \$PARENT in ranger|vim|nvim) echo -n "\$PARENT" ;; esac"
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

# Remove all aliases
unalias -m '*'

alias e='$EDITOR'
alias f='$FILE_MANAGER'

# Colors
alias ls="ls -v --color=auto"
alias grep="grep --color=auto"

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
alias -g G='|grep -Pi'
alias -g T='|tail'
alias -g H='|head'
alias -g N='&>/dev/null'

# Start new instance only if it is not running in current shell
case $PARENT in
    ranger|vim|nvim) alias $PARENT='exit' ;;
esac

# Color man pages ----------------------------------------------------------{{{1

export LESS_TERMCAP_mb=$'\E[41m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;31m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[04;34m'


# Functions-----------------------------------------------------------------{{{1

formiko-vim () {
    # detach command
    (command formiko-vim "$1" &>/dev/null &)
}

