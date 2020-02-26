#! /bin/bash

i3-msg -t get_workspaces \
	| jq -c '
		map(select(.visible))
		| sort_by(.focused | not)
		| .[].num' \
	| while read -r num; do
	echo "$num"
	out="$(i3-msg '[class="Firefox" workspace="'"$num"'"] focus' | jq '.[0].success')"
	echo "$out"
	if [[ "$out" == true ]]; then
		break
	fi
done

exec firefox "$@"
