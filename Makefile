MAKEFLAGS += --warn-undefined-variables
SHELL := bash -o pipefail -c
.DEFAULT_GOAL := help

HAS_BREW := $(shell command -v brew 2>/dev/null)
HAS_MAS := $(shell command -v mas 2>/dev/null)

## Display this help
help:
	@ echo 'Usage: make <target>'
	@ echo
	@ echo 'Available targets are:'
	@ awk '/^[[:alnum:]]+([\.\-_][[:alnum:]]*)*:/ \
		{if (match(line, /^## (.*)/)) { \
			printf "    %s^%s\n", substr($$1, 0, index($$1, ":")-1), substr(line, RSTART + 3, RLENGTH); \
		}} { line = $$0 }' $(MAKEFILE_LIST) | sort | column -t -s^
	@ echo
.PHONY: help

## Run systems checks
doctor:
ifndef HAS_BREW
	$(error Please run '$$ make init' first)
endif
ifndef HAS_MAS
	$(error Please run '$$ make init' first)
endif
	@ brew doctor || true
	@ mas account >/dev/null
.PHONY: doctor

## Setup system
init:
ifndef HAS_BREW
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
endif
ifndef HAS_MAS
	brew install mas
endif
	@ ./mas-signin.sh

	@ make files

	@ echo 'Update "~/.profile" file with following content:'
	@ echo '# ----- osx-setup ----- #'
	@ cat files/profile
	@ echo '# ----- osx-setup ----- #'
.PHONY: init

## Same as make brew files
sync: apps files
.PHONY: sync

## Install/update applications
apps:
	brew update
	brew bundle -v
	brew bundle cleanup
	brew bundle dump --describe --global --force
	@ echo "🍺  Configuration is dumped to $(HOME)/.Brewfile"
.PHONY: apps

## Sync files
files:
	mkdir -p ~/.local/shell ~/.gnupg ~/.ssh
	rsync -a files/shell/ ~/.local/shell/
	rsync -a files/ssh/ ~/.ssh/
	rsync -a files/gnupg/ ~/.gnupg/
.PHONY: files

## Check for updates
check:
	brew bundle check --verbose
.PHONY: check

## List installed apps
info:
	@ echo "🍺  Installed Taps:"
	brew bundle list --taps

	@ echo "🍺  Installed Brews:"
	brew bundle list --brews

	@ echo "🍺  Installed Casks:"
	brew bundle list --casks

	@ echo "🍺  Installed MASes:"
	brew bundle list --mas
.PHONY: info

## Remove unattended applications
clean:
	brew bundle cleanup --zap --force
.PHONY: clean
