#!/usr/bin/env zsh

# install Homebrew and dependencies

if ! command_exists /opt/homebrew/bin/brew; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if command_exists brew; then
  # update Brewfile to bring in any vscode or mas changes, avoiding reinstalling
  # uninstalled apps when running `brew bundle --global install` below
  update_global_brewfile
else
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

brew bundle --global install

# Use Homebrew version of Zsh

text_red_bold='\033[1;31m'
text_reset='\033[0m'

if [[ -z "$(eval grep "$(brew --prefix)/bin/zsh" /etc/shells)" ]]; then
  echo "===> Attempting to add Homebrew version of Zsh to allowed shell list"
  echo "$(brew --prefix)/bin/zsh" | sudo tee -a /etc/shells || echo "\n${text_red_bold}ALERT: action required${text_reset}\n\nFailed to add Homebrew version of Zsh to allowed shell list. Run the following command as an admin\n\n$ echo \"\$(brew --prefix)/bin/zsh\" | sudo tee -a /etc/shells"
fi

if [[ $SHELL != "/opt/homebrew/bin/zsh" ]]; then
  echo "===> Attempting to change shell to Homebrew version of Zsh"
  chsh -s "$(brew --prefix)/bin/zsh" "$USER" || echo "\n${text_red_bold}ALERT: action required${text_reset}\n\nFailed to set shell to Homebrew version of Zsh. Run the following command as an admin\n\nchsh -s \"\$(brew --prefix)/bin/zsh\" \"\$USER\""
fi
