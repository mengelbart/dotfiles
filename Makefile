# Create symlinks for dotfiles using stow

MODULES := bash bin vim git X11 i3 kitty zathura systemd
MAC_MODULES := bash vim git kitty
SWAY_MODULES := sway

ifeq (, $(shell which git))
	$(error "No git in $$PATH, install it first")
endif

ifeq (, $(shell which stow))
	$(error "No stow in $$PATH, install it first")
endif

DOTFILESDIR := $(shell dirname "$(readlink -f "$0")")

.PHONY: stow sway macbook unstow

all: stow

stow:
	stow -v -t ~ -d $(DOTFILESDIR) --restow $(MODULES)

sway:
	stow -t ~ -d $(DOTFILESDIR) --restow $(SWAY_MODULES)

macbook:
	stow -t ~ -d $(DOTFILESDIR) --restow $(MAC_MODULES)

unstow:
	stow -t ~ -d $(DOTFILESDIR) --delete $(MODULES)

