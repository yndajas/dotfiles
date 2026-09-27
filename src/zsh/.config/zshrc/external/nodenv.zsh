#!/usr/bin/env zsh

path_excludes "${HOME}/.nodenv/shims" && command_exists nodenv && \
  source_cached nodenv nodenv init - --no-rehash
