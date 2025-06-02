#!/usr/bin/env zsh

[[ -z "${original_brew_command}" ]] && original_brew_command="$(command -v brew)"
function brew() {
  # just run brew if there are no arguments
  [[ $# -eq 0 ]] && eval "${original_brew_command}" && return 0

  # otherwise run original brew command
  # and if that was successful, update the global Brewfile if needed
  eval "${original_brew_command}" "${*}" && case "${1}" in
    install | uninstall | remove | rm | tap | untap)
      echo '==> Updating Brewfile'
      update_global_brewfile
      ;;
      *) return;;
    esac
}

[[ -z "${original_mas_command}" ]] && original_mas_command="$(command -v mas)"
function mas() {
  # just run mas if there are no arguments
  [[ $# -eq 0 ]] && eval "${original_mas_command}" && return 0

  # otherwise run original mas command
  # and if that was successful, update the global Brewfile if needed
  eval "${original_mas_command}" "${*}" && if [[ "${1}" == 'install' ]]; then
    echo '==> Updating Brewfile'
    update_global_brewfile
  fi
}
