export PYTHONFAULTHANDLER=1

export PIP_DISABLE_PIP_VERSION_CHECK=1
export PIP_PROGRESS_BAR="off"

export PIPENV_HIDE_EMOJIS=1
export PIPENV_IGNORE_VIRTUALENVS=1
export PIPENV_NO_INHERIT=1
export PIPENV_VENV_IN_PROJECT=1
export PIPENV_YES=1

export PIPX_DEFAULT_PYTHON="python3.11"
export PIPX_BIN_DIR="/usr/local/bin"

if test ! "${HOMEBREW_PREFIX}/bin/python3" -ef "${HOMEBREW_PREFIX}/bin/${PIPX_DEFAULT_PYTHON}"; then
    ( 
        cd "${HOMEBREW_PREFIX}/bin" \
            && ln -nfs "${PIPX_DEFAULT_PYTHON}" python3 \
            && ln -nfs "${PIPX_DEFAULT_PYTHON/python/pip}" pip3
    )
fi
