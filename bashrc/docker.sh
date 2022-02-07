#! /bin/bash

dps() {
	docker ps "$@" --format \
		'table {{.ID}}\t{{.Image}}\t{{.Command}}\t{{.RunningFor}}\t{{.Status}}\t{{.Names}}' \
		| sed -re 's|^([0-9a-f]+\s+)containers.*:9500/|\1cbnnn/|' \
		       -e 's|^([0-9a-f]+\s+)gcr.io/google_containers/|\1gcr/|' \
		       -e 's|^([0-9a-f]+\s+)gcr.io/google-containers/|\1gcr/|' \
		       -e 's|^([0-9a-f]+\s+)registry.nflex.io/|\1nflex/|' \
		       -e 's|  +|\t|g' \
		| column -ts $'\t'
}
alias dpsa='docker ps -a'
alias drm='docker rm -fv $(docker ps -qa)'
alias dvrm='docker volume rm $(docker volume ls -q)'
dll() {
	docker logs "$(docker ps -a | head -2 | tail -1 | awk '{print $1}')"
}

export COMP_WORDBREAKS="${COMP_WORDBREAKS//:/}"
docker2tar() {
	id="$(docker create "$1" /dummy)"
	docker export "$id"
	docker rm -fv "$id" >/dev/null
}
_docker2tar() {
	local cur="${COMP_WORDS[COMP_CWORD]}"
	read -ra COMPREPLY -d'\0' < <(compgen -W "$(docker images --format "{{.Repository}}:{{.Tag}}")" "$cur")
}
complete -F _docker2tar docker2tar

if [[ "$TERM" == "xterm-termite" ]]; then
	alias docker="TERM=xterm-256color docker"
	dbash() {
		docker exec -it "$1" bash -c "TERM=xterm-256color exec bash"
	}
else
	dbash() {
		docker exec -it "$1" bash
	}
fi


