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

setupkube() {
	ssh -t "$1" bash -c '
		base=~jenkins
		if [[ -e ~cmp/.kube ]]; then
			base=~cmp
		fi

		set -x
		mkdir -p ~/.kube
		mkdir -p ~/.minikube
		sudo cp "$base/.kube/config" ~/.kube/
		sudo cp "$base/.minikube/"{ca.crt,client.crt,client.key} ~/.minikube/
		sudo chown -R "$USER:$USER" ~/.kube
		sudo chown -R "$USER:$USER" ~/.minikube

		sed -Ei "s#/home/(jenkins|cmp)#/home/$USER#g" ~/.kube/config
	'
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
		#eval output="\$($*)"
		# shellcheck disable=SC2048
		output="$($*)"
		clear
		# shellcheck disable=SC2154
		echo "$output"
		sleep 1
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
	while read -r b64; do
		<<<"$b64" base64 -d | xxd -ps | sed -r 's/^(.{8})(.{4})(.{4})(.{4})(.{12})$/\1-\2-\3-\4-\5/'
	done
}

uuidb64() {
	while read -r uuid; do
		<<<"$uuid" tr -d '-' | xxd -ps -r | base64
	done
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

splithttp() {
	hdrfile=/dev/stderr
	bdyfile=/dev/stdout
	if [[ "$#" -gt 0 && "$1" == "-h" ]]; then
		hdrfile=/dev/stdout
		bdyfile=/dev/stderr
	fi
	awk "
	BEGIN { headers=1; body=0; }
	{ if(headers) { print \$0 > \"$hdrfile\" } }
	{ if(body) { print \$0 > \"$bdyfile\" } }
	/^\\r?$/ { headers=0; body=1; }"
}

htc() {
	nh="${1:-10}"
	nt="${2:-$nh}"
	awk "NR<=$nh{ print } { lines[NR] = \$0; delete lines[NR-$nt]; } END{ for(line in lines) {print lines[line]}; print NR }"
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

if command -v ncal >/dev/null; then
	alias cal='ncal -b'
fi

klogs() {
	appname="$1"
	shift

	while true; do
		sleep 1
		read -r podname status < <(kubectl get pod \
			-l "cmp-app=$appname" \
			-o custom-columns=name:.metadata.name,status:.status.containerStatuses[0].state.waiting.reason \
			| tail -n+2 \
			| tail -n1)

		case "$status" in
			PodInitializing)
				echo "--- init"
				kubectl logs "$podname" "$appname-migration" -f "$@"
				;;
			*)
				echo "---"
				kubectl logs "$podname" -f "$@"
				;;
		esac
	done
}
