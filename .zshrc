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
path=(~/.local/bin ~/.composer/vendor/bin $path)
typeset -gU path

# Man path
MANPATH=`env MANPATH= manpath`
manpath=(~/.local/man $manpath)
typeset -gU manpath

# Function path
# ~/.oh-my-zsh/custom/fpath.zsh

# Variables ----------------------------------------------------------------{{{1

# Parent process name
PARENT=$(ps -p $PPID -o comm=)

# hide this user from prompt
export DEFAULT_USER="fpob"

if [[ -n $SSH_CONNECTION || -n $MC_SID ]]; then
    export BROWSER="lynx"
    export EDITOR="vim"
else
    export BROWSER="firefox"
    export EDITOR="vim"
fi

# Python startup script
[[ -f $HOME/.pythonrc ]] && export PYTHONSTARTUP=$HOME/.pythonrc

# `ts` environment
export TS_ENV="pwd"

# Python virtualenvwrapper variables
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Projects
export VIRTUALENVWRAPPER_PYTHON=`which python3`
export VIRTUAL_ENV_DISABLE_PROMPT=1

# ssh key
#export SSH_KEY_PATH="~/.ssh/dsa_id"

# History
HISTFILE=$HOME/.zsh_history
HISTSIZE=2500
SAVEHIST=5000

# Oh My Zsh ----------------------------------------------------------------{{{1

export ZSH=$HOME/.oh-my-zsh

if [[ -n $MC_SID ]] ; then
    ZSH_THEME="simple"
else
    ZSH_THEME="powerlevel9k/powerlevel9k"
fi

# Nastaveni
#CASE_SENSITIVE="true"
DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

# Pluginy
plugins=(sudo zsh_reload git git-flow autojump taskwarrior
         python pip virtualenvwrapper django gulp bower composer)

# Pridani podpory precmd a preexec, bez toho nefunguje theme powerlevel9k
autoload -U add-zsh-hook
add-zsh-hook precmd  omz_termsupport_precmd
add-zsh-hook preexec omz_termsupport_preexec

source $ZSH/oh-my-zsh.sh

# Reinicializace doplnovani, kvuli vlastnim doplnovani
autoload -Uz compinit
compinit -d "$ZSH_CACHE_DIR/zcomp-$HOST"

# Opravy jen u nazvu prikazu, ne vsude
unsetopt correct_all
setopt correct

# Prompt -------------------------------------------------------------------{{{1

function prompt_anime_aid () {
    [[ -f .aid ]] && "${1}_prompt_segment" "$0" "$2" cyan black "a`cat .aid`"
}

function prompt_parent () {
    case $PARENT in
        ranger|vim)
            "${1}_prompt_segment" "$0" "$2" black yellow "$PARENT" ;;
    esac
}

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(status root_indicator context dir)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(anime_aid vcs virtualenv background_jobs ssh parent)
POWERLEVEL9K_STATUS_VERBOSE=false
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_ROOT_ICON=$'\u2622'

# Bindkey ------------------------------------------------------------------{{{1

bindkey -s '\el' 'l\n'

# Aliasses -----------------------------------------------------------------{{{1

# Remove all aliases
unalias -m '*'

# Colors
alias ls="ls -v --color=auto"
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

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

# Task Spooler
alias ts='tsp'

# TaskWarrior
alias t='nocorrect task'

# force 256 colors
alias tmux='tmux -2'

alias man='nocorrect man'
alias mkdir='nocorrect mkdir -p'
alias mv='nocorrect mv'
alias tcpdump='sudo tcpdump'

# Copy & Paste Clipboard
alias ci='xclip -i -sel c'
alias co='xclip -o -sel c'

alias tsv="column -t -s$'\t'"
alias mdv='mdv -t 884.0134'
alias gdb='gdb -q'
alias bc='bc -ql'
alias octave='octave -q --no-gui'

# Global aliasses
alias -g L='|less'
alias -g G='|grep'
alias -g T='|tail'
alias -g H='|head'
alias -g W='|wc'
alias -g N='&>/dev/null'

# Start new instance only if it is not running in current shell
case $PARENT in
    ranger|vim) alias $PARENT='exit' ;;
esac

# Color man pages ----------------------------------------------------------{{{1

export LESS_TERMCAP_mb=$'\E[41m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;31m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[04;34m'
