#!/usr/bin/env zsh

function catls() {
  if [[ -f "$1" ]]; then
    cat "$1"
  else
    ls "$1"
  fi
}
