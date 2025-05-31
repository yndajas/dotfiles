#!/usr/bin/env zsh

# use bat to add syntax highlighting to man
# see https://github.com/sharkdp/bat#man
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

function manual() {
  if [[ $(whence -w $1 | grep builtin) ]]; then
    man -P "less --pattern \"^       $1( |$)\"" zshbuiltins
  else
    man $@
  fi
}
