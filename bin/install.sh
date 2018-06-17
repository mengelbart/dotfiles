#!/bin/bash

set -e
set -o pipefail

check_sudo() {
	if [ "$EUID" -ne 0 ]; then
		echo "Please run as root."
		exit
	fi
}

setup_sources() {
	cat <<-EOF > /etc/apt/sources.list
	deb http://ftp.de.debian.org/debian/ stretch main contrib non-free
	deb-src http://ftp.de.debian.org/debian/ stretch main contrib non-free
	
	deb http://security.debian.org/debian-security stretch/updates main contrib non-free
	deb-src http://security.debian.org/debian-security stretch/updates main contrib non-free
	
	# stretch-updates, previously known as 'volatile'
	deb http://ftp.de.debian.org/debian/ stretch-updates main contrib non-free
	deb-src http://ftp.de.debian.org/debian/ stretch-updates main contrib non-free
	EOF
}

base() {
	apt update
	apt -y upgrade
	apt install -y --no-install-recommends \
		curl \
		git \
		make \
		network-manager \
		sudo \
		unzip \
		rxvt-unicode-256color \
		vim-nox

	apt autoremove
	apt autoclean
	apt clean
}


install_graphics() {
	apt install -y --no-install-recommends \
		xorg \
		xserver-xorg \
		xserver-xorg-video-intel
}

install_wm() {

	apt install -y --no-install-recommends \
		feh \
		i3 \
		i3lock \
		i3status \
		suckless-tools \

	mkdir -p /etc/X11/xorg.conf.d/
	curl -sSL https://raw.githubusercontent.com/mengelbart/dotfiles/master/etc/X11/xorg.conf.d/50-synaptics-clickpad.conf > /etc/X11/xorg.conf.d/50-synaptics-clickpad.conf

	curl -sSL https://raw.githubusercontent.com/jessfraz/dotfiles/master/etc/fonts/local.conf > /etc/fonts/local.conf

}

install_wifi() {
	apt install -y --no-install-recommends \
		firmware-brcm80211
	modprobe -r brcmsmac ; modprobe brcmsmac
}

install_dotfiles() {
	(
	git clone git@github.com:mengelbart/dotfiles.git "${HOME}/dotfiles"
	cd "${HOME}/dotfiles"

	make

	cd "$HOME"
	)

	install_vim;
}

install_vim() {
	(
	sudo rm -rf "${HOME}/.vim"
	git clone --recursive git@github.com:mengelbart/.vim.git "${HOME}/.vim"
	cd "${HOME}/.vim"
	make install
	)
}

main() {
	local cmd=$1
	
	if [[ $cmd == "base" ]]; then
		check_sudo
		setup_sources
		base
	elif [[ $cmd == "graphics" ]]; then
		check_sudo
		install_graphics
	elif [[ $cmd == "wm" ]]; then
		check_sudo
		install_wm
	elif [[ $cmd == "wifi" ]]; then
		check_sudo
		install_wifi
	elif [[ $cmd == "dotfiles" ]]; then
		install_dotfiles
	elif [[ $cmd == "vim" ]]; then
		install_vim
	fi

}

main "$@"


