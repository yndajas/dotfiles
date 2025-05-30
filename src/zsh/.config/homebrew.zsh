#!/usr/bin/env zsh

if command_exists /opt/homebrew/bin/brew; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

[[ -z $original_brew_command ]] && original_brew_command="$(which brew)"
function brew() {
  # just run brew if there are no arguments
  [[ $# -eq 0 ]] && eval ${original_brew_command} && return 0

  # otherwise run original brew command
  # and if that was successful, update the global Brewfile if needed
  eval ${original_brew_command} "$@" && case $1 in
    install | uninstall | remove | rm | tap | untap)
      echo '\n==> Updating Brewfile'
      update_global_brewfile
      ;;
    esac
}

[[ -z $original_mas_command ]] && original_mas_command="$(which mas)"
function mas() {
  # just run mas if there are no arguments
  [[ $# -eq 0 ]] && eval ${original_mas_command} && return 0

  # otherwise run original mas command
  # and if that was successful, update the global Brewfile if needed
  eval ${original_mas_command} "$@" && if [[ "$1" == 'install' ]]; then
    echo '\n==> Updating Brewfile'
    update_global_brewfile
  fi
}
