
setup-server() {
	hostname=$1
	command=$2
	address=$3

	if [[ $(hostname -s) != $hostname ]]; then
		alias $command="mosh $address"
	fi
}

setup-server nyx nyx nyx.gn32.uk
setup-server nyx bot32 bot32@nyx.gn32.uk
setup-server erebus erebus erebus.gn32.uk
setup-server tyche tyche tyche.gn32.uk
setup-server themis themis themis.gn32.uk
