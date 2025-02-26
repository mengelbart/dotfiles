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

install_wm() {
	dnf install -y \
		@base-x \
		feh \
		i3 \
		i3lock \
		i3status \
		dmenu \
		dunst \
		lightdm \
		kitty \
		nmcli \
		light \
		htop \
		thunar \
		rofi \
		powertop \
		arandr \
		fontawesome-fonts-all
}

install_dotfiles() {
	(
	mkdir -p "${HOME}/src/github.com/mengelbart"
	git clone git@github.com:mengelbart/dotfiles.git "${HOME}/src/github.com/mengelbart/dotfiles"
	cd "${HOME}/dotfiles"

	make

	cd "$HOME"
	)

	install_vim;
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

main() {
	local cmd=$1
	
	if [[ $cmd == "wm" ]]; then
		check_sudo
		install_wm
	elif [[ $cmd == "dotfiles" ]]; then
		install_dotfiles
	elif [[ $cmd == "go" ]]; then
		install_go
	fi

}

main "$@"


