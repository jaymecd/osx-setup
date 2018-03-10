#!/bin/sh

set -e

main () {
  did_login=0

  if ! mas account >/dev/null 2>&1; then
    _login
    did_login=1
  fi

  echo "Logged as: $(mas account)"

  if [ "${did_login}" -eq 1 ]; then
    echo "You may now close 'App Store' window."
    echo "Thank you!"
  fi
}

_login () {
  echo "Attention! Login to 'App Store' is required."
  echo "After window is opened, navigate to >Store and then >Sign In..."
  echo "  press <Enter> continue or Ctrl+C to abort ..."
  read -r

  open -a "/Applications/App Store.app"

  until (mas account > /dev/null); do
    sleep 1
  done
}

main "$@"
