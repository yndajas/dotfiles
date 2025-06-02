#!/usr/bin/env zsh

function warn_about_shellcheck_issues {
  local shellcheck_command="shellcheck --shell=bash --wiki-link-count=100 ${HOME}/.zshenv ${HOME}/.zshrc ${HOME}/.config/zshrc/**/*.zsh"

  { eval "${shellcheck_command}" --format=quiet; } || { \
    set_text_format --foreground red && \
    echo -e "Warning: issues identified with dotfiles\n\$ ${shellcheck_command}"; \
  }
}
