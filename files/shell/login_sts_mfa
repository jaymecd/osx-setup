_sts_mfa_list()
{
    cur="${COMP_WORDS[COMP_CWORD]#*=}"
    profiles="$(grep -E '^\[ *[a-zA-Z0-9_-]+ *\]$' ~/.aws/credentials 2>/dev/null | tr -d '[]' | sed -e '/^sts-/d' | sort | uniq)"
    COMPREPLY=( $(compgen -W "${profiles}" -- ${cur}) )
}

complete -F _sts_mfa_list sts_mfa login_sts

login_sts () {
    local profile="${1:-}"

    test -n "${profile}" || { echo >&2 "ERROR: specify profile"; return 1; }

    mfa_token "sts-${profile}" | sts_mfa "${profile}"
}
