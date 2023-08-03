export HOMEBREW_PREFIX="/opt/homebrew";
export HOMEBREW_CELLAR="${HOMEBREW_PREFIX}/Cellar";
export HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}";

_GNU_BIN=$(/bin/ls -1d "${HOMEBREW_PREFIX}"/opt/*/libexec/gnubin | paste -s -d: -)
_GNU_MAN=$(/bin/ls -1d "${HOMEBREW_PREFIX}"/opt/*/libexec/gnuman | paste -s -d: -)

if [ -x /usr/libexec/path_helper ]; then
    eval $(MANPATH= /usr/libexec/path_helper -s)
fi

export PATH="${_GNU_BIN}:${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin${PATH+:$PATH}";
export MANPATH="${_GNU_MAN}:${HOMEBREW_PREFIX}/share/man${MANPATH+:$MANPATH}";
export INFOPATH="${HOMEBREW_PREFIX}/share/info${INFOPATH+:INFOPATH}";

unset _GNU_BIN _GNU_MAN
