#!/usr/bin/env zsh

alias cat="bat"

# use bat to add syntax highlighting to man
# (https://github.com/sharkdp/bat#man)
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
