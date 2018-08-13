
export FZF_DEFAULT_OPTS="--history-size=99999 --history=$HOME/.bash_eternal_history"

for f in /usr/share/fzf/*.bash; do
	if [[ -e "$f" ]]; then
		. "$f"
	fi
done
