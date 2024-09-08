. "$HOME/.cargo/env"

function command_exists() {
  command -v $1 > /dev/null 2>&1
}

export DOTFILES_DIR="~/code/github.com/yndajas/dotfiles"

# useful for updating vscode and mas entries before brew bundle install is run
# by the dotfiles install script, which could reinstall anything that's been
# removed
function update_global_brewfile() {
  brew bundle dump --file=${DOTFILES_DIR}/src/homebrew/.Brewfile --describe --force --no-lock
}
