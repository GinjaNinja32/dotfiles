# base64 can't handle no padding, so we add it
_base64_decode() {
	case $((${#1} % 4 )) in
		3) input="$1=";;
		2) input="$1==";;
		*) input="$1";; # 1 shouldn't be possible, just pass it through so base64 errors on it
	esac
	echo "$input" | tr '_-' '/+' | base64 -d
}

parse_jwt() {
IFS=. read -r header claims signature
cat <<EOF | jq .
{"header":$(_base64_decode "$header"),"claims":$(_base64_decode "$claims"),"signature":"$signature"}
EOF
}
