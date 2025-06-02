#!/usr/bin/env zsh

command_exists ssh-agent && \
  eval "$(ssh-agent)" > /dev/null && ssh-add -q --apple-load-keychain
