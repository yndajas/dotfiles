#!/usr/bin/env zsh

function manual() {
  if whence -aw "${1}" | grep --quiet builtin; then
    man -P "less --pattern \"^       ${1}( |$)\"" zshbuiltins
  else
    man "${@}"
  fi
}
