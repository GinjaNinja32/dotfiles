#! /bin/bash

export EDITOR=vim

_pathprepend "$HOME/.local/bin"
_pathprepend "$HOME/bin" "$HOME/dotfiles/scripts" "$HOME/dotfiles/scripts/steam"

[[ -e /usr/local/go ]] && _pathappend /usr/local/go/bin
[[ -e "$HOME/.cargo/bin" ]] && _pathappend "$HOME/.cargo/bin"
