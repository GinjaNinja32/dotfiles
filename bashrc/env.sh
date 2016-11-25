#! /usr/bin/env bash

export EDITOR=vim

[ -e "$HOME/bin/hub/hub" ] && export PATH="$HOME/bin/hub:$PATH"
[ -e "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"
