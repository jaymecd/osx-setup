GPG_TTY="${TTY:-"$(tty)"}"
SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

export GPG_TTY SSH_AUTH_SOCK

gpgconf --quiet --launch gpg-agent

gpg_refresh_key() {
    gpg-connect-agent updatestartuptty /bye
    echo | gpg -s > /dev/null
}
