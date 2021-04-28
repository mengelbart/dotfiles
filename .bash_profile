
if [ -f ~/.profile ]; then
	. ~/.profile
fi

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
source "$HOME/.cargo/env"
