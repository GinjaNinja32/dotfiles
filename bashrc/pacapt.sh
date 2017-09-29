#! /bin/bash

if ! which pacman >/dev/null; then
	export PATH="$PATH:$HOME/git/pacapt"
fi
