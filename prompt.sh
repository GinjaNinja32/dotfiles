#! /usr/bin/env bash

if [ -e "$HOME/bin/includes/git-prompt.sh" ]; then
	export GIT_PS1_SHOWDIRTYSTATE=yes
	export GIT_PS1_SHOWSTASHSTATE=yes
	export GIT_PS1_SHOWUNTRACKEDFILES=yes
	export GIT_PS1_SHOWUPSTREAM="auto verbose name"
	source "$HOME/bin/includes/git-prompt.sh"
else
	__git_ps1() {
		return
	}
fi

pcomm() {
	code=$?
	print=""
	if [ "$code" -ne "0" ]; then
		print="[$code] "
	fi

	export pcode=$print
}

export PROMPT_COMMAND=pcomm

if [[ "$USER" == "root" ]]; then
	usercolor=$RED
else
	usercolor=$GREEN
fi
dircolor=$BLUE
gitcolor=$YELLOW
errcolor=$RED
export PS1="\[$BOLD$usercolor\]\u@\h \[$dircolor\]\w \[$gitcolor\]\$(__git_ps1 '%s ')\[$errcolor\]\$pcode\[$RESETALL\]\n\[$BOLD\]\\$ \[$RESETALL\]"

case "$TERM" in
	xterm*|rxvt*)
		export PS1="\[\e]0;\u@\h:\w\a\]$PS1" ;;
	*) ;;
esac
