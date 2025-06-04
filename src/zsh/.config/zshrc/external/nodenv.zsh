#!/usr/bin/env zsh

path_excludes "${HOME}/.nodenv/shims" && command_exists nodenv && \
  eval "$(nodenv init -)"
