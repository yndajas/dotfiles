#!/usr/bin/env zsh

function install_mdformat() {
  if brew list mdformat &> /dev/null; then
    echo '==> Removing Homebrew mdformat, which cannot take plugins'
    brew uninstall mdformat || return 1
  fi

  echo '==> Installing mdformat with plugins'
  pipx install mdformat || return 1
  pipx inject mdformat mdformat-gfm mdformat-frontmatter
}

function warn_about_mdformat_plugins() {
  local version
  version="$(mdformat --version 2> /dev/null)"

  if [[ "${version}" != *mdformat-gfm* ]] ||
    [[ "${version}" != *mdformat_frontmatter* ]]; then
    set_text_format --foreground red
    echo -e "Warning: mdformat is missing plugins\n\$ install_mdformat"
  fi

  set_text_format --reset
}
