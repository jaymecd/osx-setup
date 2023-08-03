ssh_preload_keys() {
  local key

  for key in $(ls -1 ~/.ssh/*.pem); do
    ssh-add --apple-use-keychain "${key}" 1>/dev/null
  done
}

ssh_compile_config() {
  if [ -d ~/.ssh/config.d/ ]; then
    echo -e "# THIS IS COMPILED VERSION, ANY MANUAL CHANGES WOULD BE LOST\n" > ~/.ssh/config
    cat ~/.ssh/config.d/* >> ~/.ssh/config
  fi
}
