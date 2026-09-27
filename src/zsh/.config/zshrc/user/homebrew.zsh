#!/usr/bin/env zsh

export HOMEBREW_CASK_OPTS=--appdir=~/Applications

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
