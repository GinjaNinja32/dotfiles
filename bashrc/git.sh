#! /bin/bash

alias gc='git commit'
alias gca='git commit --amend'
alias gcra='git commit --amend --reset-author'
alias gd='git diff'
alias gdc='git diff --cached'
alias gf='git fetch --all'
alias gp='git push'
alias gpp='git pull'
alias gs='git status'
alias ggrep='git grep -B0 -A0'
alias ggrepi='git grep -i -B0 -A0'
alias gu='git stash && git pull && git stash pop'
alias dw="bwatch 'git diff --color=always | head -n\$(( \$(tput lines) - 1 ))'"

gws() {
	stashargs=()
	while [[ "$1" =~ ^- ]]; do
		if [[ "$1" == "--" ]]; then
			shift
			break
		fi
		stashargs=("${stashargs[@]}" "$1")
		shift
	done

	out="$(git stash "${stashargs[@]}")"
	echo "$out"
	git "$@"
	if [[ "$out" =~ 'Saved working directory' ]]; then
		git stash pop
	fi
}

wgs() {
	stashargs=()
	while [[ "$1" =~ ^- ]]; do
		if [[ "$1" == "--" ]]; then
			shift
			break
		fi
		stashargs=("${stashargs[@]}" "$1")
		shift
	done

	out="$(git stash "${stashargs[@]}")"
	echo "$out"
	"$@"
	if [[ "$out" =~ 'Saved working directory' ]]; then
		git stash pop
	fi
}
