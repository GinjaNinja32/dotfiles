#! /bin/bash
[[ -e $HOME/dotfiles/bashrc-ni ]] && for k in $HOME/dotfiles/bashrc-ni/*; do
	source "$k"
done

[[ "$-" != *i* ]] && return

for k in $HOME/dotfiles/bashrc/*; do
	source "$k"
done
