#! /bin/bash

_pathmerge() {
	npath=""
	for i in "$@"; do
		if [[ $npath == "" ]]; then
			npath="$i"
		else
			npath="$npath:$i"
		fi
	done

	echo "$npath" | awk '
		BEGIN {
			FS=":"
			OFS=":"
		}

		{
			for(i=1; i<=NF; i++) {
				if(!seen[$i]++) {
					printf "%s%s", colon, $i
					colon = ":"
				}
			}
		}
	'
}

_pathprepend() { export PATH="$(_pathmerge "$@" "$PATH")" ; }
_pathappend() {  export PATH="$(_pathmerge "$PATH" "$@")" ; }

_manappend() { export MANPATH="$(_pathmerge "$MANPATH" "$@")" ; }

_ldappend() { export LD_LIBRARY_PATH="$(_pathmerge "$LD_LIBRARY_PATH" "$@")" ; }
