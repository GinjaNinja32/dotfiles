#! /usr/bin/env bash

# if git prompt is installed, use it
if [ -e "$HOME/bin/includes/git-prompt.sh" ]; then
	export GIT_PS1_SHOWDIRTYSTATE=yes
	export GIT_PS1_SHOWSTASHSTATE=yes
	export GIT_PS1_SHOWUNTRACKEDFILES=yes
	export GIT_PS1_SHOWUPSTREAM="auto verbose name"
	source "$HOME/bin/includes/git-prompt.sh"
else
	# otherwise define a dummy function so bash doesn't complain
	__git_ps1() {
		return
	}
fi

__code_ps1() {
	c=$?
	if [ $c -ne 0 ]; then
		if [[ 128 -lt $c ]] && [[ $c -le 192 ]]; then
			echo "[$c SIG$(kill -l $((c - 128)))] "
		else
			echo "[$c] "
		fi
	fi
}

# Primary prompt color, based on user/host
case "$USER@$(hostname)" in
	root@*)
		__pri=9 # Red prompt for root
		;;
	*)
		__pri=10 # Green prompt for normal
		;;
esac

__tput() {
	echo -n \\[$(/usr/bin/tput "$@")\\]
}

PS1="\
$(__tput bold)\
$(__tput setaf $__pri)\\u@\\h \
$(__tput setaf 4)\\w \
$(__tput setaf 11)\$(__git_ps1 '%s ')\
$(__tput setaf 9)\$(__code_ps1)\
\n\
$(__tput setaf 15)\$$(__tput sgr0) "

case "$TERM" in
	xterm*|rxvt*)
		PS1="\[\e]0;\u@\h:\w\a\]$PS1" ;;
	*) ;;
esac
