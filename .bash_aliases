#!/bin/bash

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'
else
    alias ls='ls -G'
fi

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
#alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias tf='terraform'
alias g='git'
alias d='docker'
alias dc='docker-compose'
alias v='nvim'
alias ssh='TERM=xterm-color ssh'
alias k='kubectl'

alias less='less -Q'
alias man='man -P "less -Q"'

alias dif="kitty +kitten diff"

# add completion for aliases
#
# if something is broken, try to find the correct completion function for
# the original (non-aliased) command with:
# complete -p <command>

_completion_loader git
complete -o bashdefault -o default -o nospace -F __git_wrap__git_main g

_completion_loader docker
complete -o bashdefault -o default -o nospace -F _docker d


complete -o bashdefault -o default -o nospace -F __start_kubectl k

