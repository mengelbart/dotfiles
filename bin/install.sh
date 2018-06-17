#!/bin/bash

set -e
set -o pipefail

base() {
	apt-get install -y --no-install-recommends \
		git \
		unzip
}


install_graphics() {
	apt-get install -y --no-install-recommends \
		bumblebee \
	       	bumblebee-nvidia \
		bbswitch-dkms \
	       	primus
		xorg
		xserver-xorg
}

install_wm() {

	apt-get install -y --no-install-recommends \
		i3 \
		xserver-xorg-input-libinput

	mkdir -p /etc/X11/xorg.conf.d/
	curl -sSL https://raw.githubusercontent.com/jessfraz/dotfiles/master/etc/X11/xorg.conf.d/50-synaptics-clickpad.conf > /etc/X11/xorg.conf.d/50-synaptics-clickpad.conf

	curl -sSL https://raw.githubusercontent.com/jessfraz/dotfiles/master/etc/fonts/local.conf > /etc/fonts/local.conf

}


main() {
	local cmd=$1
	
	if [[ $cmd == "base" ]]; then
		base
	elif [[ $cmd == "graphics" ]]; then
		install_graphics
	elif [[ $cmd == "wm" ]]; then
		install_wm
	fi

}

main "$@"

