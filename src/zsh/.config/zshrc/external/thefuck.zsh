#!/usr/bin/env zsh

# needs to run after compinit
# (https://github.com/ajeetdsouza/zoxide#installation)
command_exists thefuck && eval "$(thefuck --alias)"
