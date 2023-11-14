#! /bin/bash

if [[ -e "/usr/share/bash-completion/completions/git" ]]; then
	source /usr/share/bash-completion/completions/git
else
	__git_complete() {
		true
	}
fi

_git_alias_with_complete() {
	# shellcheck disable=SC2139
	alias "$1=${3:-git} $2"

	eval "_git_alias_complete_$1() { _git_alias_complete $2; }"
	__git_complete "$1" "_git_alias_complete_$1"
}
_git_alias_complete() {
	words=( git "$@" "${words[@]:1}" )
	cword=$(( cword + $# ))
	__git_main
}

_git_alias_with_complete gc 'commit'
_git_alias_with_complete gca 'commit --amend'
_git_alias_with_complete gcra 'commit --amend --reset-author'
_git_alias_with_complete gco 'checkout'
_git_alias_with_complete gb 'branch'
_git_alias_with_complete gd 'diff'
_git_alias_with_complete gdc 'diff --cached'
_git_alias_with_complete gf 'fetch'
_git_alias_with_complete gps 'push'
_git_alias_with_complete gpl 'pull' gws # pull is rebase so need to gws
_git_alias_with_complete gs 'status'
_git_alias_with_complete gg 'grep -B0 -A0'
_git_alias_with_complete ggi 'grep -i -B0 -A0'
_git_alias_with_complete grpo 'remote prune origin'
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
__git_complete gws __git_main

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
