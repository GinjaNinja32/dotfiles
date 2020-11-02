#! /bin/bash

file=~/dotfiles/layouts/"$(hostname)".sh
if [[ -e "$file" ]]; then
	bash "$file"
fi
