#!/usr/bin/env zsh

# shellcheck disable=1083,1089,2168
# Zsh-specific syntax
function {
  local shellcheck_command='shellcheck --shell=bash --wiki-link-count=100 ~/.zshenv ~/.zshrc ~/.config/zsh/*.zsh'

  { eval "${shellcheck_command}" --format=quiet; } || { \
    set_text_format --foreground red && \
    echo -e "Warning: issues identified with dotfiles\n\$ ${shellcheck_command}"; \
  }
}
