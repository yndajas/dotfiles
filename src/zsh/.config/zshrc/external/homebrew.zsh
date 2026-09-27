#!/usr/bin/env zsh

if ! path_includes "/opt/homebrew/bin" "/opt/homebrew/sbin" && \
  command_exists /opt/homebrew/bin/brew; then
  source_cached brew_shellenv /opt/homebrew/bin/brew shellenv
fi
