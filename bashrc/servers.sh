#! /bin/bash

setup-server() {
	# shellcheck disable=SC2139
	alias "$1=mosh $1"
}

setup-server bot32
setup-server erebus
setup-server themis
setup-server thanatos
