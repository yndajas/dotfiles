#!/usr/bin/env zsh

path_excludes "${HOME}/.rbenv/shims" && command_exists rbenv && \
  eval "$(rbenv init -)"
