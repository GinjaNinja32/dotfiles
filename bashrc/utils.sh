#! /usr/bin/env bash

lagstat() {
	expd=$1
	shift
	ping $@ | sed -ur 's/.*time=([^.]*)(.*)? ms/\1/' | while read -r i; do if [[ $i > $expd ]]; then echo "$(date +%R) $i"; fi; done | tail --lines=+2
}
