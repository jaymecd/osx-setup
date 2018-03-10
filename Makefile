SHELL := bash

HAS_BREW := $(shell command -v brew 2>/dev/null)
HAS_MAS := $(shell command -v mas 2>/dev/null)

# COLORS
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)


TARGET_MAX_CHAR_NUM=20
## Show help
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
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

## Install dependencies
deps: 
ifndef HAS_BREW
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
endif
ifndef HAS_MAS
	brew install mas
endif
	@ ./mas-signin.sh
.PHONY: deps

## Run systems checks
doctor:
	@ brew doctor || true
	@ mas account >/dev/null
.PHONY: doctor

## Install/update applications
sync:
	@ brew bundle -v
	@ brew bundle cleanup
	@ brew bundle dump --describe --global --force
	@ echo "🍺  Configuration is dumped to $(HOME)/.Brewfile"
.PHONY: sync

## Check for updates
check:
	@ brew bundle check
.PHONY: check

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
.PHONY: info

## Remove unattended applications
clean:
	brew bundle cleanup --zap --force
.PHONY: clean
