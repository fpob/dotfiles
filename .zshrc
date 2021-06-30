# Tmux ---------------------------------------------------------------------{{{1

if [[ $- == *i* && -n $SSH_CONNECTION && -z $TMUX && -z $MC_SID ]] ; then
    # If session "main" exists then attach otherwise create
    tmux -2 new -A -s main
fi

# Variables ----------------------------------------------------------------{{{1

export EDITOR=${EDITOR:-vim}

# Python startup script
export PYTHONSTARTUP=$HOME/.pythonrc
# Use ipdb with Python 3.7 breakpoint
export PYTHONBREAKPOINT=ipdb.set_trace

# `ts` environment
export TS_ENV="pwd"

# golang
export GOPATH=$HOME/.go

# rust
export CARGO_HOME=$HOME/.cargo

# Default less options
export LESS=-RK

# https://stackoverflow.com/questions/51504367
export GPG_TTY=$(tty)

# Change jq colors, see `man jq`
export JQ_COLORS='1;31:1;35:1;35:0;39:0;32:1;39:1;39'

# Paths --------------------------------------------------------------------{{{1

# Bin path
path=(~/.bin ~/.local/bin $CARGO_HOME/bin $GOPATH/bin $path)
typeset -gU path

# Man path
if command -V manpath &>/dev/null ; then
    MANPATH=$(env MANPATH= manpath)
else
    MANPATH=/usr/local/man:/usr/local/share/man:/usr/share/man
fi
manpath=(~/.local/man $manpath)
typeset -gU manpath

# Oh My Zsh / load .zsh ----------------------------------------------------{{{1

export ZSH_D=$HOME/.zsh

# OMZ paths
export ZSH=$ZSH_D/oh-my-zsh
export ZSH_CUSTOM=$ZSH_D/oh-my-zsh-custom

if [[ -n $MC_SID || $TERM = 'linux' ]] ; then
    ZSH_THEME="simple"
else
    ZSH_THEME="powerlevel10k/powerlevel10k"
fi

# https://github.com/ohmyzsh/ohmyzsh/blob/master/templates/zshrc.zsh-template
#CASE_SENSITIVE="true"
DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="false"
COMPLETION_WAITING_DOTS="true"
DISABLE_AUTO_UPDATE="true"
ZLE_REMOVE_SUFFIX_CHARS=""
DISABLE_MAGIC_FUNCTIONS="true"

plugins=(
    colored-man-pages
    direnv
    fd
    fzf
    golang
    kitty
    kubectl
    pip
    pueue
    python
    ranger
    sudo
    vault
    zsh-autosuggestions
    zsh-completions
    zsh_reload
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Remove all aliases from OMZ plugins
unalias -m '*'

# reload completion functions
autoload -Uz compinit && compinit

# Load all custom config files
function {
    local config_file
    for config_file ($ZSH_D/*.zsh(N)) ; do
        source $config_file
    done
}

# Terminal title -----------------------------------------------------------{{{1

# Inspired by oh-my-zsh/lib/termsupport.zsh
function term_title_precmd {
    # %3~ = 3 trailing components of path
    local tab_title="zsh:%15<..<%3~%<<"     # 15 char left truncated PWD
    local win_title="zsh:%3~"               # 3 elements of path
    title $tab_title $win_title
}

# Run before showing the prompt
autoload -U add-zsh-hook
add-zsh-hook precmd term_title_precmd

# History setup ------------------------------------------------------------{{{1
# Has to be done after OMZ setup

export HISTFILE=$HOME/.zsh_history
export HISTSIZE=25000
export SAVEHIST=$HISTSIZE

# Don't record an entry starting with a space.
setopt HIST_IGNORE_SPACE
# Delete old recorded entry if new entry is a duplicate.
setopt HIST_IGNORE_ALL_DUPS
# Don't write duplicate entries in the history file.
setopt HIST_SAVE_NO_DUPS

# Syntax highlight setup ---------------------------------------------------{{{1
# https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md

typeset -A ZSH_HIGHLIGHT_STYLES

ZSH_HIGHLIGHT_STYLES[path]='none'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=245'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=245'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=42'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=42'

# GRC (autoapply for commands) ---------------------------------------------{{{1

[[ "$TERM" != dumb ]] && (( $+commands[grc] )) && function {
    local blacklist conf name

    # GRC prefix for other aliasses in. If GRC is not installed or cannot be
    # used this var will be empty (default shell var value).
    export _GRC='grc --colour=auto '

    blacklist=(ls)

    # Set alias for available colorfiles and commands.
    for conf in ~/.grc/conf.*(.N) /usr/local/share/grc/conf.*(.N) /usr/share/grc/conf.*(.N) ; do
        name=${conf##*conf.}

        # Don't use it for builtins
        (( $+builtins[$name] )) && continue
        # Blacklist some commands
        (( $blacklist[(Ie)$name] )) && continue

        if (( $+commands[$name] )) ; then
            alias $name="$_GRC$(whence $name)"
        fi
    done

}

# Aliasses -----------------------------------------------------------------{{{1

alias e='$EDITOR'
alias f='ranger'
alias g='git'

alias xo='xdg-open'

alias ls='ls -v --color=auto -CF'
alias l='ls'
alias ll='l -hl --time-style="+%Y-%m-%d %H:%M"'
alias la='l -A'
alias lla='ll -A'

# COW copy if available
alias cp='cp --reflink=auto'

alias rcp='rsync -hhh --info=progress2'

# Human readable sizes
alias du=$_GRC'du -khc'
alias df=$_GRC'df -kTh'
alias free=$_GRC'free -th'

alias grep='grep --color=auto'
alias gr='grep --exclude-dir={.bzr,CVS,.git,.hg,.svn,.tox}'
alias gri='gr -i'
alias rgr='gr -r'
alias rgri='gri -r'
alias ggr='git ls-files --cached --others --exclude-standard -z | xargs -0 grep --color=auto -nT'
alias ggri='ggr -i'

alias py='python3'
alias pydoc='pydoc3'
alias pyvenv='python3 -m venv'
alias ipy='ipython3 --pdb --'   # start debugger on uncaught exception
alias pip='noglob pip'          # allows square brackets for pip command
alias pip3='noglob pip3'

# force 256 colors
alias tmux='tmux -2'

# Copy & Paste Clipboard
alias ci='xsel -ib'
alias co='xsel -ob'

# Curl with kerberos auth
alias kcurl='curl -u : --negotiate'
# JSON Curl
alias jcurl='curl -H "Accept: application/json" -H "Content-type: application/json"'

# Cut long lines
alias cll='cut -c -$COLUMNS'
# Format CSV/TSV as table (aligned)
alias csv="column -t -s,"
alias tsv="column -t -s$'\t'"

alias gdb='gdb -q'
alias bc='bc -ql'
alias octave='octave -qW'

alias gpg='gpg-pinentry-loopback'
# Cat GPG encrypted file.
alias gpg-cat='gpg-pinentry-loopback -qd -o-'

alias pa='pueue add --'

alias a='ansible'
alias ap='ansible-playbook'
alias av='ansible-vault'
alias ad='ansible-doc'
alias adl='ansible-doc -t lookup'

# "Rename" back commands that are renamed in Debian packages because of
# conflicts with some other commands.
if ( source /etc/os-release && [[ $ID == debian ]] ) ; then
    alias bat=batcat
    alias fd=fdfind
fi

# Global aliasses
alias -g L='|less -FX'
alias -g LL='2>&1|less -FX'
alias -g G='|grep'
alias -g T='|tail'
alias -g H='|head'
alias -g N='&>/dev/null'

# Functions ----------------------------------------------------------------{{{1

# Wrapper for yt to convert output back to YAML with preserved styles and add
# syntax highlighting.
function yq {
    command yq -Y $@ | bat -pl yaml
}

# Kitty (completion, aliasses, ...) ----------------------------------------{{{1

# Kitty is installed and currently using it.
if command -v kitty &>/dev/null && [[ $TERM = xterm-kitty ]] ; then

    # Show image in terminal.
    alias icat='kitty +kitten icat'

    # SSH kitten is just wrapper around ssh command that fixes terminfo.
    # *Required* because *#$%@! in ncurses database, see discussion on
    # https://github.com/kovidgoyal/kitty/issues/879
    #alias ssh='kitty +kitten ssh'
    alias ssh='TERM=xterm-256color ssh'

    # Diff Styled -- diff with colors, syntax, ...
    alias difs='kitty +kitten diff'

fi
