# if not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# ----- osx-setup ----- #
test ! -f "${HOME}/.bashrc" || source "${HOME}/.bashrc"

for _FILE in "${HOME}/.local/shell/"*.sh; do
    test ! -r "${_FILE}" || source "${_FILE}"
done

unset _FILE
# ----- osx-setup ----- #
