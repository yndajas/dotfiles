#!/usr/bin/env zsh

function install_mdformat() {
  if brew list mdformat &> /dev/null; then
    echo '==> Removing Homebrew mdformat, which cannot take plugins'
    brew uninstall mdformat || return 1
  fi

  echo '==> Installing mdformat with GFM support'
  pipx install mdformat || return 1
  pipx inject mdformat mdformat-gfm
}

function warn_about_mdformat_plugins() {
  if ! mdformat --version 2> /dev/null | grep --quiet 'mdformat-gfm'; then
    set_text_format --foreground red
    echo -e "Warning: mdformat can't format Markdown tables\n\$ install_mdformat"
  fi

  set_text_format --reset
}
