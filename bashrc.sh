#! /bin/bash

[[ "$-" != *i* ]] && return

for k in $HOME/dotfiles/bashrc/*; do
	source "$k"
done
