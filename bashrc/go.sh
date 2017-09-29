#! /bin/bash

case "$(hostname)" in
	bp-arch)
		export GOPATH=/repos/go
		;;
	*)
		export GOPATH=$HOME/go
		;;
esac

_pathappend $GOPATH/bin

