#! /bin/bash

[[ "$-" != *i* ]] && return

srcifex() {
	[ -f "$1" ] && source $1
}

srcifex "$HOME/byond/setup.sh"

srcifex "$HOME/dotfiles/colordefs.sh"
srcifex "$HOME/dotfiles/misc.sh"
srcifex "$HOME/dotfiles/aliases.sh"
srcifex "$HOME/dotfiles/local.sh"
true
