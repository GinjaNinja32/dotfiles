#! /bin/bash

if [ -x /usr/bin/dircolors ]; then
	if [[ "$TERM" =~ 256 ]]; then
		dircolfile=$HOME/dotfiles/dircolors/256
	else
		dircolfile=$HOME/dotfiles/dircolors/16
	fi
	test -r $dircolfile && eval "$(dircolors -b $dircolfile)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi
