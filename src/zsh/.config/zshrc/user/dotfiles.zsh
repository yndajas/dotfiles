#!/usr/bin/env zsh

function dotfiles() {
  local command=''
  local valid_commands=(cd code install)
  local usage_text="usage: dotfiles <command>

Commands:
   cd         change into the directory of the dotfiles repository
   code       open the dotfiles repository in VS Code
   install    (re)install the dotfiles (idempotent)"

  [[ $# -gt 1 ]] && echo "${usage_text}" && return 1

  if [[ $# -eq 1 ]]; then
    # shellcheck disable=1087,2128,2250
    # Zsh-specific syntax
    { (( "$valid_commands[(Ie)${1}]" )) && command="${1}"; } || { echo "${usage_text}" && return 1; }
  fi

  # shellcheck disable=1087,2128,2250
  # Zsh-specific syntax
  while ! (( "$valid_commands[(Ie)$command]" )); do
    vared -p 'Enter command (cd/code/install): ' command
  done

  case "${command}" in
    cd) cd "${DOTFILES_DIR}" || return 1;;
    code) code "${DOTFILES_DIR}";;
    install) eval "${DOTFILES_DIR}/install";;
    *) echo 'Error: invalid argument(s)'; return 1;;
  esac
}

function warn_about_unsynced_dotfiles {
  if [[ -n "$(git -C "${DOTFILES_DIR}" status --porcelain)" ]]; then
    set_text_format --foreground red
    echo "Warning: uncommitted changes in ${DOTFILES_DIR}"
  elif [[ -n "$(git -C "${DOTFILES_DIR}" diff "@{upstream}")" ]]; then
    set_text_format --foreground red
    echo "Warning: unpushed changes in ${DOTFILES_DIR}"
  fi
}
