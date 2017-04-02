#! /usr/bin/env bash

# General
export EDITOR=vim
export PATH="$HOME/bin:$HOME/bin/scripts:$HOME/bin/scripts/steam:$PATH"

# Hub
[ -e "$HOME/bin/hub/hub" ] && export PATH="$HOME/bin/hub:$PATH"

# Go
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# BYOND
export BYOND_SYSTEM=$HOME/byond/lin/use
export PATH="$PATH:$HOME/byond/lin/use/bin"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/byond/lin/use/bin"
export MANPATH="$MANPATH:$HOME/byond/lin/use/man"
