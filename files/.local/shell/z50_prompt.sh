function __prompt_command() {
    declare -r status="$?"

    history -a

    declare -r x="\[\e[0m\]"
    declare -r b="\[\e[0;30m\]"
    declare -r r="\[\e[0;31m\]"
    declare -r g="\[\e[0;32m\]"
    declare -r gr="\[\e[1;30m\]"
    declare -r y="\[\e[0;33m\]"
    declare -r bl="\[\e[1;34m\]"
    declare -r p="\[\e[0;35m\]"
    declare -r c="\[\e[0;36m\]"
    declare -r w="\[\e[0;37m\]"
    declare -r lvl="\[\e(0\]mq\[\e(B\]" # line-drawing characters

    declare ps1_start='' ps1_end=''

    if test "${status}" -ne 0; then
        ps1_start+="${x}  ${lvl}(${r}exit ${status}${x})\n"
    fi

    if test "${EUID}" -eq 0; then
        ps1_start+="\n${r}"
    else
        ps1_start+="\n${y}"
    fi

    ps1_start+="${MY_HOST_NAME:-\h}"

    ps1_start+=" ${bl}\w"
    ps1_end+=" ${x}\n${lvl}[${c}\t${x}] "

    if test "${status}" -ne 0; then
        ps1_end+="${r}\$${x} "
    else
        ps1_end+="${g}\$${x} "
    fi

    declare git_status
    git_status=$(__gitstatus | xargs)

    if test -n "${git_status}"; then
        declare git_utype
        git_utype=$(git config user.type 2>/dev/null || :)
        ps1_start+=" ${y}(${git_utype:+${git_utype::1} }${git_status})"
    fi

    if test -n "${VIRTUAL_ENV:-}" -a -f "${VIRTUAL_ENV}/pyvenv.cfg"; then
        declare venv
        venv=$(awk '$1=="version" {print $NR}' "${VIRTUAL_ENV}/pyvenv.cfg")
        ps1_start+=" ${gr}(venv:${venv})"
    fi

    declare ws_ps1
    ws_ps1=$(__ws_ps1_label 2>/dev/null)

    if test -n "${ws_ps1:-}"; then
        ps1_start+=" ${gr}(${ws_ps1})"
    fi

    if test -n "${AWS_PROFILE:-}"; then
        declare aws_region
        aws_region=$(echo "${AWS_DEFAULT_REGION:-}" | sed -e 's/north/n/;s/east/e/;s/south/s/;s/west/w/;s/central/c/;s/-//g')
        ps1_start+=" ${gr}(aws${aws_region:+:${aws_region}} ${AWS_PROFILE})"
    fi

    PS1="${ps1_start}${ps1_end}"

    return "${status}"
}

PROMPT_COMMAND='__prompt_command'

# disable expansion of '$(...)' and the like
shopt -u promptvars
