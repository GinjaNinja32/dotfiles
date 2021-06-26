#! /usr/bin/env bash

HISTCONTROL=ignoreboth
shopt -s histappend
export HISTSIZE=
export HISTFILESIZE=
if ! [[ "$PROMPT_COMMAND" =~ history\ -a ]]; then
	PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'history -a'
	export PROMPT_COMMAND
fi
export HISTFILE=~/.bash_eternal_history
shopt -s checkwinsize
shopt -s globstar
shopt -s extglob

if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

stty stop undef
stty start undef
