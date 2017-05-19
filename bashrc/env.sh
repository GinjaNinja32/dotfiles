#! /usr/bin/env bash

# General
export EDITOR=vim
export PATH="$HOME/bin:$HOME/bin/scripts:$HOME/bin/scripts/steam:$PATH"

# Hub
[ -e "$HOME/bin/hub/hub" ] && export PATH="$HOME/bin/hub:$PATH"

# Go

case "$(hostname)" in
	bp-arch)
		export GOPATH="/repos/go"
		;;
	*)
		export GOPATH="$HOME/go"
		;;
esac

export PATH="$PATH:$GOPATH/bin"

# BYOND
export BYOND_SYSTEM="$HOME/byond/lin/use"
export PATH="$PATH:$HOME/byond/lin/use/bin"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/byond/lin/use/bin"
export MANPATH="$MANPATH:$HOME/byond/lin/use/man"

# Pacapt (if needed)
if ! which pacman >/dev/null; then
	export PATH="$PATH:$HOME/git/pacapt"
fi
