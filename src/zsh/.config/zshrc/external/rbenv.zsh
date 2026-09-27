#!/usr/bin/env zsh

path_excludes "${HOME}/.rbenv/shims" && command_exists rbenv && \
  source_cached rbenv rbenv init - --no-rehash
