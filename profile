#! /bin/bash

[ -e "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"

export GTK_IM_MODULE=xim
export QT_IM_MODULE=xim

[ -e "$HOME/.bashrc" ] && . "$HOME/.bashrc"
