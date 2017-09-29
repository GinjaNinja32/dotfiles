#! /bin/bash

alias lh='ls -sh'
alias ll='ls -alFh'
alias la='ls -Ah'
alias l='ls -CFh'

alias sprunge='curl -F "sprunge=<-" http://sprunge.us'

alias mosh='mosh --predict=experimental'
alias scp='scp -S ssh'

alias tmux='tmux -2'
txr() { fst=${1:-}; shift; tmux a -t "$fst" "$@"; } # screen -x
tdr() { fst=${1:-}; shift; tmux a -dt "$fst" "$@"; } # screen -dr
alias tn='tmux new -s' # screen -mS
alias tls='tmux ls 2>/dev/null || echo "No tmux sessions running"'

mcd() { mkdir -p $1; cd $1; }
smcd() { sudo mkdir -p $1; cd $1; }

setupterm() {
	infocmp $TERM | ssh $1 tic -
}

setupubuntubashrc() {
	ssh $1 sed -i '"s/xterm-color/xterm-termite|xterm-color/g"' .bashrc
	echo -e "\ncd ~jenkins/shared/deploy || cd ~jenkins/shared/env/deploy || cd ~cmp/shared/deploy" | ssh $1 tee -a .bashrc > /dev/null
}

pkg() {
	pkg=$1
	repo=$(pacman -Ss $pkg | grep "/$pkg " | sed 's|/.*||')

	if [[ $pkg != "" && $repo != "" ]]; then
		chromium "http://archlinux.org/packages/$repo/x86_64/$pkg/"
	fi
}

bwatch() {
	while true; do
		eval output="\$($*)"
		clear
		echo "$output"
		sleep 0.5
	done
}

rand() {
	cat /dev/urandom | head -c $1
}

hex() {
	xxd -ps -c 100000000000
}

unhex() {
	xxd -ps -r
}

lagstat() {
	expd=$1
	shift
	ping $@ | sed -ur 's/.*time=([^.]*)(.*)? ms/\1/' | while read -r i; do if [[ $i > $expd ]]; then echo "$(date +%R) $i"; fi; done | tail --lines=+2
}
