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

# useful for updating mas and possibly go and cargo (and vscode, when
# installed), entries before brew bundle install is run by the dotfiles install
# script, which could reinstall anything that's been removed
function update_global_brewfile() {
  brew bundle dump --file="${DOTFILES_DIR}/src/homebrew/.Brewfile" --describe --force
}

function prepare_ruby_for_vim() {
  if [[ ! -f ".ruby-version" ]]; then
    echo "No .ruby-version" && return 1
  fi

  local version
  version=$(cat .ruby-version)

  if [[ ! -d "${HOME}/.rbenv/versions/${version}" ]]; then
    echo "==> Installing Ruby"
    rbenv install
  fi

  if [[ ! -f "${HOME}/.rbenv/versions/${version}/bin/ruby-lsp" ]]; then
    echo "==> Installing ruby-lsp gem"
    gem install ruby-lsp
  fi

# -- 3. install ruby-lsp if required -- should this actually be bundle install?
# what about rubocop-govuk?
# -- ~/.rbenv/versions/VERSION/bin/rubocop
# -- gem install rubocop

  echo "==> Done!"
}
