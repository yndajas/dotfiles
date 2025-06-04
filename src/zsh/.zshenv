#!/usr/bin/env zsh

function command_exists() {
  command -v "${1}" > /dev/null 2>&1
}

function path_includes() {
  [[ $# -eq 0 ]] && return 1

  while [[ $# -gt 0 ]]; do
    [[ ":${PATH}:" != *":${1}:"* ]] && return 1
    shift
  done
}

function path_excludes() {
  [[ $# -eq 0 ]] && return 1

  while [[ $# -gt 0 ]]; do
    [[ ":${PATH}:" == *":${1}:"* ]] && return 1
    shift
  done
}

export DOTFILES_DIR="${HOME}/code/github.com/yndajas/dotfiles"

# useful for updating vscode and mas entries before brew bundle install is run
# by the dotfiles install script, which could reinstall anything that's been
# removed
function update_global_brewfile() {
  brew bundle dump --file="${DOTFILES_DIR}/src/homebrew/.Brewfile" --describe --force
}
