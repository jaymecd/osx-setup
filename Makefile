MAKEFLAGS += --warn-undefined-variables --no-print-directory
SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help

HAS_BREW := $(shell command -v brew 2>/dev/null)
HAS_MAS := $(shell command -v mas 2>/dev/null)

# COLORS
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)

.PHONY: help
.PHONY: doctor init
.PHONY: sync info check clean

TARGET_MAX_CHAR_NUM=10
## Display this help
help:
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  ${YELLOW}%-$(TARGET_MAX_CHAR_NUM)s${RESET} ${GREEN}%s${RESET}\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST) | sort

## Run systems checks
doctor:
ifndef HAS_BREW
	$(error Please run '$$ make deps' first)
endif
ifndef HAS_MAS
	$(error Please run '$$ make deps' first)
endif
	@ brew doctor || true
	@ mas account >/dev/null

## Setup system
init:
ifndef HAS_BREW
	ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
endif
ifndef HAS_MAS
	brew install mas
endif
	@ ./mas-signin.sh

	@ rsync -a files/shell/ ~/.local/shell/
	@ rsync -a files/gnupg/ ~/.gnupg/

	@ echo 'Update "~/.profile" file with following content:'
	@ echo '# ----- osx-setup ----- #'
	@ cat files/profile
	@ echo '# ----- osx-setup ----- #'

## Install/update applications
sync:
	@ brew update
	@ brew bundle -v
	@ brew bundle cleanup
	@ brew bundle dump --describe --global --force
	@ echo "🍺  Configuration is dumped to $(HOME)/.Brewfile"
	@ rsync -a files/shell/ ~/.local/shell/
	@ rsync -a files/gnupg/ ~/.gnupg/

## Check for updates
check:
	@ brew bundle check

## List installed apps
info:
	@ echo "🍺  Installed Taps:"
	@ brew bundle list --taps

	@ echo "🍺  Installed Brews:"
	@ brew bundle list --brews

	@ echo "🍺  Installed Casks:"
	@ brew bundle list --casks

	@ echo "🍺  Installed MASes:"
	@ brew bundle list --mas

## Remove unattended applications
clean:
	brew bundle cleanup --zap --force
