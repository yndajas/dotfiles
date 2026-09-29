#!/usr/bin/env zsh

export HOMEBREW_CASK_OPTS=--appdir=~/Applications

okta_extension_app_id=1439967473
[[ "$(hostname)" == MAC* ]] ||
  export HOMEBREW_BUNDLE_MAS_SKIP="${okta_extension_app_id}"
unset okta_extension_app_id

function brew() {
  [[ $# -eq 0 ]] && command brew && return 0

  command brew "${@}" && case "${1}" in
    install | uninstall | remove | rm | tap | untap)
      echo '==> Updating Brewfile'
      update_global_brewfile
      ;;
      *) return;;
    esac
}

function mas() {
  [[ $# -eq 0 ]] && command mas && return 0

  command mas "${@}" && if [[ "${1}" == 'install' ]]; then
    echo '==> Updating Brewfile'
    update_global_brewfile
  fi
}
