#!/usr/bin/env zsh

# Every Zsh reads this file, interactive or not, so it holds only what
# non-interactive shells need: exported environment variables, and functions
# called by scripts, by Neovim's `!`, or by dotbot's shell steps. Anything used
# only by interactive shells belongs in .config/zshrc instead

function command_exists() {
  command -v "${1}" > /dev/null 2>&1
}

export DOTFILES_DIR="${HOME}/code/github.com/yndajas/dotfiles"

alias glow='glow -p -s ${HOME}/.config/glow.json'

# properly reflows hard-wrapped lines that are over- or under-length relative to
# glow's width
# remove once this PR lands: https://github.com/charmbracelet/glow/pull/985
function cleanglow() {
  glow "${@:2}" <(pandoc --from=gfm --to=gfm --wrap=none -- "${1}")
}

# useful for updating mas and possibly go and cargo (and vscode, when
# installed), entries before brew bundle install is run by the dotfiles install
# script, which could reinstall anything that's been removed
function update_global_brewfile() {
  brew bundle dump --file="${DOTFILES_DIR}/src/homebrew/.Brewfile" --force
}

function install_mdformat() {
  if brew list mdformat &> /dev/null; then
    echo '==> Removing Homebrew mdformat, which cannot take plugins'
    brew uninstall mdformat || return 1
  fi

  echo '==> Installing mdformat with plugins'
  pipx install mdformat || return 1
  pipx inject mdformat mdformat-gfm mdformat-frontmatter
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
