#!/usr/bin/env zsh

if [[ $- == *i* ]]; then
  command_exists zoxide && source_cached zoxide zoxide init zsh --cmd cd
fi
