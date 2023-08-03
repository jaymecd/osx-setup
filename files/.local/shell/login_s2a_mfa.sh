_s2a_mfa_list()
{
    cur_word="${COMP_WORDS[COMP_CWORD]}"

    #Strip out options
    while [ "${COMP_WORDS[1]::1}" == '-' ]; do
        COMP_WORDS=("${COMP_WORDS:1}")
        COMP_CWORD=$((COMP_CWORD-1))
    done

    case "$COMP_CWORD" in

        0|1) # aws profiles
            profiles=$(cat ~/.aws/config | python3 -c 'import configparser, sys; p = configparser.ConfigParser(); p.read_file(sys.stdin); print(" ".join([s.replace("profile ","") for s in p.sections() if p.get(s, "user_type", fallback="") == "saml"]))' | sort | uniq)
            COMPREPLY=( $(compgen -W "${profiles}" -- "${cur_word}") )
            ;;

        2)  # saml2aws-auto
            groups=$(cat ~/.saml2aws-auto.yml | python3 -c 'import sys,yaml; d=yaml.safe_load(sys.stdin); print("\n".join(d["groups"].keys()))' | grep "^${COMP_WORDS[1]}-" | sed -e "s/^${COMP_WORDS[1]}-//")

            COMPREPLY=( $(compgen -W "${groups}" -- "${cur_word}") )
            ;;
    esac

}

complete -F _s2a_mfa_list login_s2a

login_s2a() {
    local profile="${1}"
    local group="${2}"

    test -n "${group}" || { echo >&2 "ERROR: specify profile"; return 1; }

    mfa_token "${profile}-s2a" | xargs -I{} saml2aws-auto refresh "${profile}-${group}" --mfa {} --force
}
