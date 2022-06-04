# XDG_RUNTIME_DIR is set and created by systemd-logind
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
