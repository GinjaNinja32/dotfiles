#! /usr/bin/env bash

export EDITOR=vim

[ -e "$HOME/bin/hub/hub" ] && export PATH="$HOME/bin/hub:$PATH"

export GOPATH="$HOME/go"

export PATH="$HOME/bin:$HOME/bin/scripts:$PATH:$GOPATH/bin"

