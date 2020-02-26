
export FZF_DEFAULT_OPTS="--history-size=99999 --history=$HOME/.bash_eternal_history"

_pathprepend ~/git/fzf/bin

for f in ~/git/fzf/shell/*.bash; do
	if [[ -e "$f" ]]; then
		. "$f"
	fi
done
