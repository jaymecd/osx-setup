export LC_ALL="en_IE.UTF-8"
export LANG="en_IE.UTF-8"
export EDITOR=vi

# unlimited history
HISTCONTROL=ignoreboth
HISTSIZE=-1
HISTFILESIZE=-1
HISTTIMEFORMAT="[%F %T] "
HISTFILE="${HOME}/.bash_history_full"

shopt -s histappend
shopt -s checkwinsize

# @see https://support.apple.com/en-us/HT208050
BASH_SILENCE_DEPRECATION_WARNING=1

# @see https://superuser.com/questions/61185/why-do-i-get-files-like-foo-in-my-tarball-on-os-x
COPYFILE_DISABLE=true

test ! -r "${HOMEBREW_PREFIX}/etc/bash_completion" || source "${HOMEBREW_PREFIX}/etc/bash_completion"

export SSL_CERT_FILE="${HOMEBREW_PREFIX}/etc/openssl@1.1/cert.pem"
export CURL_CA_BUNDLE="${SSL_CERT_FILE}"
export HTTPLIB2_CA_CERTS="${SSL_CERT_FILE}"

# export PATH="${HOME}/.local/bin:${PATH}"
