#!/usr/bin/env zsh

if [[ $- == *i* ]]; then
  command_exists zoxide && eval "$(zoxide init zsh --cmd cd)"
fi
