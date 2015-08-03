#! /bin/bash

export GIT_PS1_SHOWDIRTYSTATE=yes
export GIT_PS1_SHOWSTASHSTATE=yes
export GIT_PS1_SHOWUNTRACKEDFILES=yes
export GIT_PS1_SHOWUPSTREAM="auto verbose name"
source ~/bin/includes/git-prompt.sh

[ -e "$HOME/bin/hub/hub" ] && export PATH="$HOME/bin/hub:$PATH"

HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize
shopt -s globstar
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
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
export PS1="\[$BOLD$GREEN\]\u@\h \[$BLUE\]\w \[$YELLOW\]\$(__git_ps1 '%s') \[$RED\]\$pcode\[$RESETALL\]\n\[$BOLD\]\$ \[$RESETALL\]"

case "$TERM" in
	xterm*|rxvt*)
		export PS1="\[\e]0;\u@\h:\w\a\]$PS1" ;;
	*) ;;
esac

# Allow ^S inside screen to not stop output
stty stop undef
stty start undef

export JAVA_HOME=/usr/lib/jvm/java-7-oracle
