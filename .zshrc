# Tmux ---------------------------------------------------------------------{{{1

if [[ $- == *i* && -n $SSH_CONNECTION && -z $TMUX && -z $MC_SID ]] ; then
    # If session "main" exists then attach otherwise create
    tmux -2 new -A -s main
fi

# Oh My Zsh ----------------------------------------------------------------{{{1

# OMZ paths
export ZSH=$HOME/.zsh/oh-my-zsh
export ZSH_CUSTOM=$HOME/.zsh/oh-my-zsh-custom

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
ZLE_REMOVE_SUFFIX_CHARS=""
DISABLE_MAGIC_FUNCTIONS="true"

zstyle ':omz:update' mode disabled

# https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]='none'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=245'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=245'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=42'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=42'

zstyle ':grc:ls' disable yes

plugins=(
    binenv
    cheat
    colored-man-pages
    direnv
    fd
    fzf
    golang
    grc
    kitty
    kubectl
    pip
    pueue
    python
    ranger
    ripgrep
    sudo
    vault
    zsh-autosuggestions
    zsh-completions
    zsh-syntax-highlighting
    zsh_reload
)

source $ZSH/oh-my-zsh.sh

# Remove all aliases from OMZ plugins
unalias -m '*'

# reload completion functions
autoload -Uz compinit && compinit

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

# Variables ----------------------------------------------------------------{{{1

export EDITOR=${EDITOR:-vim}

# Python startup script
export PYTHONSTARTUP=$HOME/.pythonrc
export REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

# golang
export GOPATH=$HOME/.go
export GO111MODULE=on

# rust
export CARGO_HOME=$HOME/.cargo

# Default less options
export LESS=-RK

# https://stackoverflow.com/questions/51504367
export GPG_TTY=$(tty)

# Change jq colors, see `man jq`
export JQ_COLORS='1;31:1;35:1;35:0;39:0;32:1;39:1;39'

export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow --exclude .git'

# Aliases ------------------------------------------------------------------{{{1

# "Rename" back commands that are renamed in Debian packages because of
# conflicts with some other commands.
if ( source /etc/os-release && [[ $ID == debian ]] ) ; then
    alias bat=batcat
    alias fd=fdfind
fi

# https://askubuntu.com/questions/22037/aliases-not-available-when-using-sudo
alias sudo='sudo '

alias e='${EDITOR:-vim}'
alias f='ranger'
alias g='git'

alias xo='xdg-open'

alias ls='ls -v --color=auto --hyperlink=auto -CF'
alias l='ls'
alias ll='l -hl --time-style="+%Y-%m-%d %H:%M"'
alias la='l -A'
alias lla='ll -A'

# COW copy if available
alias cp='cp --reflink=auto'

alias rcp='rsync -hhh --info=progress2'

# Human readable sizes
alias du='du -khc'
alias df='df -kTh'
alias free='free -th'

alias rg='rg -S'
alias rgl='rg -l'

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

alias bc='bc -ql'

# GPG with CLI pinentry mode in a terminal
alias gpg='gpg --pinentry-mode loopback'

alias pa='pueue add --'

alias py='python3'
alias pydoc='pydoc3'
alias pyvenv='python3 -m venv'
alias ipy='ipython3 --pdb --'   # start debugger on uncaught exception
alias pip='noglob pip'          # allows square brackets for pip command
alias pip3='noglob pip3'

alias a='ansible'
alias ap='ansible-playbook'
alias av='ansible-vault'
alias ad='ansible-doc'
alias adl='ansible-doc -t lookup'
alias ag='ansible-galaxy'

# Extra aliasses in Kitty terminal
if [[ $TERM = xterm-kitty ]] ; then
    # Show image in terminal.
    alias icat='kitty +kitten icat'
    # SSH kitten is just wrapper around ssh command that fixes terminfo.
    # *Required* because kitty is not in ncurses database, see discussion on
    # https://github.com/kovidgoyal/kitty/issues/879
    #alias ssh='kitty +kitten ssh'
    alias ssh='TERM=xterm-256color ssh'
fi

# Load extra scripts -------------------------------------------------------{{{1

# Load all custom config files
function {
    local config_file
    for config_file ($HOME/.zsh/*.zsh(N)) ; do
        source $config_file
    done
}
