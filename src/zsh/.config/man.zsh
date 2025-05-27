#!/usr/bin/env zsh

# use bat to add syntax highlighting to man
# see https://github.com/sharkdp/bat#man
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

function man-builtin() {
  man -P "less +/\ \ \ \ \ \ \ $1\ " zshbuiltins
}
