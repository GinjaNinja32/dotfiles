
#! /bin/bash

if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto'
        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
fi

alias lh='ls -sh'
alias ll='ls -alFh'
alias la='ls -Ah'
alias l='ls -CFh'

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# One command for creating and changing directories
mcd() { mkdir $1; cd $1; }
smcd() { sudo mkdir $1; cd $1; }

# Short forms of commands
alias "sr=screen -r"
alias "sdr=screen -dr"
alias c=clear

alias nano="nano -wxOST 4"

alias sprunge="curl -F 'sprunge=<-' http://sprunge.us"

alias mosh="mosh --predict=experimental"
