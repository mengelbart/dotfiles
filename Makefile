# Create symlinks for dotfiles using stow

MODULES := bash vim git X11 i3 kitty zathura systemd

ifeq (, $(shell which git))
	$(error "No git in $$PATH, install it first")
endif

ifeq (, $(shell which stow))
	$(error "No stow in $$PATH, install it first")
endif

DOTFILESDIR := $(shell dirname "$(readlink -f "$0")")

all: stow

stow:
	stow -t ~ -d $(DOTFILESDIR) --restow $(MODULES)

unstow:
	stow -t ~ -d $(DOTFILESDIR) --delete $(MODULES)

