# do not use = slow lookup
# GIT_PS1_SHOWDIRTYSTATE=true
# GIT_PS1_SHOWUNTRACKEDFILES=true
# GIT_PS1_SHOWCOLORHINTS=1

# GIT_PS1_SHOWUPSTREAM=verbose
# GIT_PS1_DESCRIBE_STYLE=describe

alias g="git"
__git_complete g __git_main

alias open_git_home="git open"

source "${HOMEBREW_PREFIX}/opt/gitstatus/gitstatus.plugin.sh"

__gitstatus() {
  gitstatus_query || return
  test "${VCS_STATUS_RESULT}" == 'ok-sync' || return

  local p

  if [[ -n "${VCS_STATUS_LOCAL_BRANCH}" ]]; then
    p+="${VCS_STATUS_LOCAL_BRANCH} @${VCS_STATUS_COMMIT:0:8}"
  elif [[ -n "${VCS_STATUS_TAG}" ]]; then
    p+="#${VCS_STATUS_TAG}"
  else
    p+="@${VCS_STATUS_COMMIT:0:8}"
  fi

  # ⇣42 if behind the remote.
  (( VCS_STATUS_COMMITS_BEHIND )) && p+=" ⇣${VCS_STATUS_COMMITS_BEHIND}"
  # ⇡42 if ahead of the remote; no leading space if also behind the remote: ⇣42⇡42.
  (( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && p+=" "
  (( VCS_STATUS_COMMITS_AHEAD  )) && p+="⇡${VCS_STATUS_COMMITS_AHEAD}"
  # ⇠42 if behind the push remote.
  (( VCS_STATUS_PUSH_COMMITS_BEHIND )) && p+=" ⇠${VCS_STATUS_PUSH_COMMITS_BEHIND}"
  (( VCS_STATUS_PUSH_COMMITS_AHEAD && !VCS_STATUS_PUSH_COMMITS_BEHIND )) && p+=" "
  # ⇢42 if ahead of the push remote; no leading space if also behind: ⇠42⇢42.
  (( VCS_STATUS_PUSH_COMMITS_AHEAD  )) && p+="⇢${VCS_STATUS_PUSH_COMMITS_AHEAD}"
  # *42 if have stashes.
  (( VCS_STATUS_STASHES        )) && p+=" *${VCS_STATUS_STASHES}"
  # 'merge' if the repo is in an unusual state.
  [[ -n "$VCS_STATUS_ACTION"   ]] && p+=" ${VCS_STATUS_ACTION}"
  # ~42 if have merge conflicts.
  (( VCS_STATUS_NUM_CONFLICTED )) && p+=" ~${VCS_STATUS_NUM_CONFLICTED}"
  # +42 if have staged changes.
  (( VCS_STATUS_NUM_STAGED     )) && p+=" +${VCS_STATUS_NUM_STAGED}"
  # !42 if have unstaged changes.
  (( VCS_STATUS_NUM_UNSTAGED   )) && p+=" !${VCS_STATUS_NUM_UNSTAGED}"
  # ?42 if have untracked files. It's really a question mark, your font isn't broken.
  (( VCS_STATUS_NUM_UNTRACKED  )) && p+=" ?${VCS_STATUS_NUM_UNTRACKED}"

  echo "${p}"
}

gitstatus_stop && gitstatus_start -s -1 -u -1 -c -1 -d -1
