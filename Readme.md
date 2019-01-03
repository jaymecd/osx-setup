# OSX Setup

Set of commands to orchestrate OSX machine.

*Inspired by [kevinelliott](https://gist.github.com/kevinelliott/7a152c556a83b322e0a8cd2df128235c/) gist.*

## Usage

To display help:

```shell
$ make [help]

Usage:
  make <target>

Targets:
  check      Check for updates
  clean      Remove unattended applications
  doctor     Run systems checks
  help       Display this help
  info       List installed apps
  init       Setup system
  sync       Install/update applications
```

To init/update system it's enough to run:

```shell
$ make init
```

This will install `brew`/`mas` if absent, copy Shell ang GnuPG config files.

```shell
$ git pull
$ make sync
```

## TODO

- [ ] doc for git setup with gpg
- [ ] system setings tuning

## Under the hood

### Install Homebrew

```shell
$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

### Install Mac App Store CLI

⚠️  `mas signin` is disabled, please follow https://github.com/mas-cli/mas/issues/164 for more information.

```shell
$ brew install mas
$ ./mas-signin.sh
# hit ENTER
```

### Install apps

```shell
$ brew bundle
```

### Check apps

```shell
$ brew bundle check
```

### Cleanup apps

```shell
$ brew bundle cleanup
$ brew bundle cleanup --force
```
