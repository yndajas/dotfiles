#!/usr/bin/env zsh

command_exists starship && { \
  type starship_zle-keymap-select > /dev/null || eval "$(starship init zsh)"; }
