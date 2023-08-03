_VAULT_IMAGE_ROOT="${HOME}/Dropbox/WareHouse"
_VAULT_IMAGE_SUFFIX="Vault.sparsebundle"

_VAULT_MOUNT_ROOT="/Volumes"
_VAULT_MOUNT_SUFFIX="Vault"

mkdir -p "${_VAULT_IMAGE_ROOT}"

_vault_names_to_open() {
  find "${_VAULT_IMAGE_ROOT}" -maxdepth 1 -type d -name "*${_VAULT_IMAGE_SUFFIX}" -prune -execdir basename {} "${_VAULT_IMAGE_SUFFIX}" \;
}

_vault_names_to_close() {
  find "${_VAULT_MOUNT_ROOT}" -maxdepth 1 -type d -name "*${_VAULT_MOUNT_SUFFIX}" -prune -execdir basename {} "${_VAULT_MOUNT_SUFFIX}" \;
}

_comlete_vault_names_to_open() {
  if test "${COMP_CWORD}" -eq 1; then
    COMPREPLY=( $(_vault_names_to_open) )
  fi
}

_comlete_vault_names_to_close() {
  if test "${COMP_CWORD}" -eq 1; then
    COMPREPLY=( $(_vault_names_to_close) )
  fi
}

complete -F _comlete_vault_names_to_open vault_read vault_write
complete -F _comlete_vault_names_to_close vault_close

_vault_open() {
  local -r name="${1##*/}"  # basename
  local -r ro="$2"

  test -n "${name}" || {
    echo >&2 "Error: vault name is missing"
    return 1
  }

  local -r image_path="${_VAULT_IMAGE_ROOT}/${name}${_VAULT_IMAGE_SUFFIX}"
  local -r mount_path="${_VAULT_MOUNT_ROOT}/${name}${_VAULT_MOUNT_SUFFIX}"

  local mount_args=( -quiet -verify )

  if test -z "${ro}"; then
    echo "Opening ${mount_path} (writable) ..."
  else
    echo "Opening ${mount_path} (readonly) ..."

    mount_args+=( -readonly )
  fi

  test ! -d "${mount_path}" || {
    echo >&2 "Error: already open"
    return 1
  }

  hdiutil attach "${mount_args[@]}" -mountpoint "${mount_path}" "${image_path}" \
    && echo "done"
}

vault_read() {
  _vault_open "$1" "1"
}

vault_write() {
  _vault_open "$1" ""
}

vault_close() {
  local names=( "$@" )
  local mount_path

  test "${#names[@]}" -gt 0 || {
    names=( $(_vault_names_to_close) )
  }

  test "${#names[@]}" -gt 0 || {
    echo "done"
    return 0
  }

  for name in "${names[@]}"; do
    mount_path="${_VAULT_MOUNT_ROOT}/${name}${_VAULT_MOUNT_SUFFIX}"

    echo "Closing ${mount_path} ..."

    {
      test ! -d "${mount_path}" \
        || hdiutil detach -quiet "${mount_path}" \
        || hdiutil detach -quiet -force "${mount_path}"
    }

    echo "done"
  done
}
