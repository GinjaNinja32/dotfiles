#! /bin/bash

alias lh='ls -sh'
alias ll='ls -alFh'
alias la='ls -Ah'
alias l='ls -CFh'

alias sprunge='curl -F "sprunge=<-" http://sprunge.us'

alias mosh='mosh --predict=experimental'
alias scp='scp -S ssh'

txr() { fst=${1:-}; shift; tmux a -t "$fst" "$@"; } # screen -x
tdr() { fst=${1:-}; shift; tmux a -dt "$fst" "$@"; } # screen -dr
alias tn='tmux new -s' # screen -mS
alias tls='tmux ls 2>/dev/null || echo "No tmux sessions running"'

mcd() { mkdir -p "$1" && cd "$1" || return; }
smcd() { sudo mkdir -p "$1" && cd "$1" || return; }

setup() {
	infocmp "$TERM" | ssh "$1" tic -
	scp ~/.remotebashrc "$1":.bashrc
}

pkg() {
	pkg=$1
	repo=$(pacman -Ss "$pkg" | grep "/$pkg " | sed 's|/.*||')

	if [[ $pkg != "" && $repo != "" ]]; then
		chromium "http://archlinux.org/packages/$repo/x86_64/$pkg/"
	fi
}

bwatch() {
	while true; do
		eval output="\$($*)"
		clear
		# shellcheck disable=SC2154
		echo "$output"
		sleep 0.5
	done
}

rand() {
	head -c "$1" /dev/urandom
}

hex() {
	xxd -ps -c 100000000000
}

unhex() {
	xxd -ps -r
}

b64uuid() {
	base64 -d | xxd -ps | sed -r 's/^(.{8})(.{4})(.{4})(.{4})(.{12})$/\1-\2-\3-\4-\5/'
}

uuidb64() {
	tr -d '-' | xxd -ps -r | base64
}

lagstat() {
	expd=$1
	shift
	ping "$@" | tail -n +2 |  sed -ur 's/.*time=([^.]*)(.*)? ms/\1/' | while read -r i; do if [[ "$i" -gt "$expd" ]]; then echo "$(date +%R) $i"; fi; done | tail --lines=+2
}

splitgrep() {
	pattern="${1//\//\\\/}"

	awk '/'"$pattern"'/ { print $0; next } { print $0 > "/dev/stderr" }'
}

htc() {
	tee >(head -n"${1:-10}" >&2; cat >/dev/null) >(tail -n"${2:-${1:-10}}" >&2) | wc -l
}

detachedmosh() {
	who | grep -v 'via mosh' | grep -oP '(?<=mosh \[)(\d+)(?=\])'
}

diff() {
	command diff \
		--old-line-format="$(tput setaf 1)-%l$(tput sgr0)"$'\n' \
		--new-line-format="$(tput setaf 2)+%l$(tput sgr0)"$'\n' \
		--unchanged-line-format=" %L" \
		"$@"
}
