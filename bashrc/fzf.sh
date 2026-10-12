_pathprepend ~/git/fzf/bin

for f in ~/git/fzf/shell/*.bash; do
	if [[ -e "$f" ]]; then
		. "$f"
	fi
done
