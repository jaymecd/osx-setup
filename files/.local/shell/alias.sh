alias cls="printf '\033[1J\r'"

alias grep="grep --color"
alias egrep="egrep --color"
alias fgrep="fgrep --color"

alias ls="ls --color"
alias ll="ls -lph"
alias l="ll -A"
alias less="less -RI"

alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

alias tree='tree -avF --dirsfirst -I ".git|.*_cache|.vscode|.venv|venv|build|htmlcov|.coverage*|__pycache__|*.py[co]|node_modules"'

__notes_make() {
  test ! -f .notes/Makefile || set -- -f Makefile -f .notes/Makefile "$@"
  make "$@"
}

alias make="__notes_make"

alias less="less -r"
alias mdcat="mdcat -p"
alias what_is_my_ip="curl -sSf -m3 http://checkip.amazonaws.com/"

dump_dns() {
  test -n "${1:-}" || return 99
  dig @8.8.8.8 +nocmd "${1}" any +noall +answer
}

# fix_hostname() {
#   local name="${1:-battle-unicorn-v4}"
#   sudo scutil --set HostName "${name}"
# }

aws_kms_decrypt_string() {
  base64 -d -w0 | aws kms decrypt --ciphertext-blob fileb:///dev/stdin --output text --query Plaintext | base64 -d -w0
}

app_metadata() {
    codesign -dv "$1" 2>&1
}

app_teamid() {
    app_metadata "$1" | awk -F= '$1=="TeamIdentifier" {print $2}'
}

app_id() {
    app_metadata "$1" | awk -F= '$1=="Identifier" {print $2}'
}

alias random_pass='LC_ALL=C tr -dc "[:alnum:]" < /dev/urandom | head -c 32'

nomad_stop() {
    launchctl unload /Library/LaunchAgents/com.trusourcelabs.NoMAD.plist
}

nomad_start() {
    launchctl load /Library/LaunchAgents/com.trusourcelabs.NoMAD.plist
}

nomad_restart() {
    nomad_stop
    nomad_start
}

nomad_debug() {
    nomad_stop 2>&1
    /Applications/NoMAD.app/Contents/MacOS/NoMAD -v -prefs -shares -rawLDAP
}

nomad_config() {
    echo "configuring NoMAD ..."

    defaults write com.trusourcelabs.NoMAD HideExpiration -bool true
    defaults write com.trusourcelabs.NoMAD HideExpirationMessage "atrema.deloitte.com"
    defaults write com.trusourcelabs.NoMAD HideGetSoftware -bool true
    defaults write com.trusourcelabs.NoMAD HideLockScreen -bool true
    defaults write com.trusourcelabs.NoMAD HidePrefs -bool true
    defaults write com.trusourcelabs.NoMAD HideQuit -bool true
    defaults write com.trusourcelabs.NoMAD HideRenew -bool false
    defaults write com.trusourcelabs.NoMAD HideSignOut -bool true
    defaults write com.trusourcelabs.NoMAD ShowHome -bool true
    defaults write com.trusourcelabs.NoMAD SignInWindowAlert -bool true
    defaults write com.trusourcelabs.NoMAD UPCAlert -bool true
    defaults write com.trusourcelabs.NoMAD UseKeychain -bool true
    defaults write com.trusourcelabs.NoMAD UserSwitch -bool true

    echo "done"
}

brave_config() {
    echo "configuring Brave ..."

    readonly auth_allow_list="*.deloitte,*.deloitte.com,*.deloitte.de,*.deloitteresources.com"

    defaults write com.brave.Browser AuthNegotiateDelegateByKdcPolicy -bool true
    defaults write com.brave.Browser DisableAuthNegotiateCnameLookup -bool true
    defaults write com.brave.Browser AuthNegotiateDelegateAllowlist "${auth_allow_list}"
    defaults write com.brave.Browser AuthServerAllowlist "${auth_allow_list}"

    echo "done"
}

alias brave="open -a /Applications/Brave\ Browser.app --"
alias chrome=brave
