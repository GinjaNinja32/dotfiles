#! /bin/bash

case "$(hostname)" in
	bp-ubuntu)
		export GOPATH=/repos/go
		;;
	*)
		export GOPATH=$HOME/go
		;;
esac

_pathappend "$GOPATH/bin"

