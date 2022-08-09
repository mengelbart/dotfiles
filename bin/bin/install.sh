#!/bin/bash

set -e
set -o pipefail

# get user, taken from jessie frazelle
get_user() {
	if [ -z "${TARGET_USER-}" ]; then
		mapfile -t options < <(find /home/* -maxdepth 0 -printf "%f\\n" -type d)
		if [ "${#options[@]}" -eq "1" ]; then
			readonly TARGET_USER="${options[0]}"
			echo "Using user account: ${TARGET_USER}"
			return
		fi

		PS3='Which user account should be used? '

		select opt in "${options[@]}"; do
			readonly TARGET_USER=$opt
			break
		done
	fi
}

check_sudo() {
	if [ "$EUID" -ne 0 ]; then
		echo "Please run as root."
		exit
	fi
}

setup_sources() {
	cat <<-EOF > /etc/apt/sources.list
	deb http://ftp.de.debian.org/debian/ buster main contrib non-free
	deb-src http://ftp.de.debian.org/debian/ buster main contrib non-free
	
	deb http://security.debian.org/debian-security buster/updates main contrib non-free
	deb-src http://security.debian.org/debian-security buster/updates main contrib non-free
	
	# buster-updates, previously known as 'volatile'
	deb http://ftp.de.debian.org/debian/ buster-updates main contrib non-free
	deb-src http://ftp.de.debian.org/debian/ buster-updates main contrib non-free
	EOF
}

base() {
	apt update
	apt -y upgrade
	apt install -y --no-install-recommends \
		alsa-utils \
		apt-transport-https \
		bc \
		brightnessctl \
		ca-certificates \
		curl \
		gcc \
		git \
		gnupg2 \
		htop \
		libncurses5-dev \
		libssl-dev \
		jq \
		make \
		network-manager \
		resolvconf \
		software-properties-common \
		sudo \
		tig \
		tree \
		unzip \
		rxvt-unicode-256color \
		vim-nox

	apt autoremove
	apt autoclean
	apt clean
}


install_graphics() {
	apt install -y --no-install-recommends \
		xcompmgr \
		xorg \
		xserver-xorg \
		xserver-xorg-video-nouveau
}

install_wm() {

	apt install -y --no-install-recommends \
		feh \
		i3 \
		i3lock \
		i3status \
		suckless-tools \

	mkdir -p /etc/X11/xorg.conf.d/
#	curl -sSL https://raw.githubusercontent.com/mengelbart/dotfiles/master/etc/X11/xorg.conf.d/50-synaptics-clickpad.conf > /etc/X11/xorg.conf.d/50-synaptics-clickpad.conf

#	curl -sSL https://raw.githubusercontent.com/jessfraz/dotfiles/master/etc/fonts/local.conf > /etc/fonts/local.conf

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
	rm -rf "${HOME}/.vim"
	git clone --recursive git@github.com:mengelbart/.vim.git "${HOME}/.vim"
	cd "${HOME}/.vim"
	make install
	)
}

install_docker() {
	apt update

	curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
	add-apt-repository \
		"deb [arch=amd64] https://download.docker.com/linux/debian \
		$(lsb_release -cs) \
		stable"

	apt update
	apt install -y \
		docker-ce

	#groupadd docker
	usermod -aG docker "$TARGET_USER"

	systemctl enable docker
}

install_go() {
	export GO_VERSION
	GO_VERSION=$(curl -sSL "https://golang.org/VERSION?m=text")
	export GO_SRC=/usr/local/go
	export GOROOT_BOOTSTRAP=/usr/local/go1.4
	if [[ ! -d "$GOROOT_BOOTSTRAP" ]]; then
		git clone https://go.googlesource.com/go "$GOROOT_BOOTSTRAP"
	fi
	if [[ -d "$GO_SRC" ]]; then
		sudo rm -rf $GO_SRC
	fi
	git clone https://go.googlesource.com/go "$GO_SRC"


	(
	cd $GOROOT_BOOTSTRAP
	git checkout release-branch.go1.4
	cd src
	./make.bash
	)

	(
	cd $GO_SRC
	git checkout $GO_VERSION
	cd src
	./all.bash
	)

}

aws_cli() {
	sudo apt-get update
	sudo apt-get install -y --no-install-recommends python-pip

	pip install setuptools
	pip install awscli --upgrade --user
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
	elif [[ $cmd == "docker" ]]; then
		get_user
		install_docker
	elif [[ $cmd == "go" ]]; then
		install_go
	elif [[ $cmd == "aws" ]]; then
		aws_cli
	fi

}

main "$@"


