# OSX Setup

Set of commands to orchestrate OSX machine.

*Inspired by [kevinelliott](https://gist.github.com/kevinelliott/7a152c556a83b322e0a8cd2df128235c/) gist.*

## Usage

To display help:

```shell
$ make
$ make help
```

To verify setup:

```shell
$ make deps doctor
```

To install/update applications:

```shell
$ git pull --rebase
$ make sync
```

## Under the hood

### Install Homebrew

```shell
$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

### Install Mac App Store CLI

```shell
$ brew install mas
$ mas signin YOUR@EMAIL.COM
```

### Install apps

```shell
$ brew bundle -v
```

### Check apps

```shell
$ brew bundle check -v
```

### Cleanup apps

```shell
$ brew bundle cleanup
$ brew bundle cleanup --force
```