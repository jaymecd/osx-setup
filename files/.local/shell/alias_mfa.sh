_MFA_ROOT="${HOME}/.local/mfa"

mkdir -p "${_MFA_ROOT}"

_mfa_tokens () {
  if test "${COMP_CWORD}" -eq 1; then
    COMPREPLY=( $(find "${_MFA_ROOT}" -maxdepth 1 -type f -execdir basename {} \;) )
  fi
}

complete -F _mfa_tokens mfa mfa_token

mfa () {
    mfa_token "${1}" | pbcopy
}

mfa_token () {
    test -f "${_MFA_ROOT}/${1}" || {
        echo >&2 "Error: unknown name"
        return 1
    }

    cat "${_MFA_ROOT}/${1}" | xargs -r -I{} -- oathtool --base32 --totp {}
}
