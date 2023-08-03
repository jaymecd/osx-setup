export DIRENV_LOG_FORMAT=

eval "$(direnv hook bash)"

direnv_init_venv() {
    local python="${1:-${PIPX_DEFAULT_PYTHON:-python3}}"

    echo "Initialising '.venv' for ${python} ..."

    echo "${python}" | grep -q '^python' || {
        echo >&2 "Error: invalid python='${python}' is used"
        return 1
    }

    test ! -f .envrc || {
        read -p "File '.envrc' already exists. Overwrite? <Ctrl+c> to cancel ... "
    }

    cat << EOF > .envrc
# read parents
source_up

# create python virtual environment
layout python "${python}"

test -d "\${PWD}/.venv" || {
   # fix: allow system-site-packages
   sed -i -e '/^include-system-site-packages/ s/false$/true/' "\${VIRTUAL_ENV}/pyvenv.cfg"

   # fix: relink to .venv/ dir
   rm -rf "\${PWD}/.venv" && mkdir -p "\${PWD}/.venv"
   find "\${VIRTUAL_ENV}"/* -prune | xargs -r -I{} -- ln -nfsr {} "\${PWD}/.venv/"
}

# fix: recreate .venv if dropped
watch_file "\${PWD}/.venv"
EOF

    direnv allow

    echo "DONE"
}
