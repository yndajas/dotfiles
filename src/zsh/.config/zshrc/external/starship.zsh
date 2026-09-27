#!/usr/bin/env zsh

command_exists starship && { \
  type starship_zle-keymap-select > /dev/null || \
    source_cached starship starship init zsh; }
