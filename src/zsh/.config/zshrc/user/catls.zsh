#!/usr/bin/env zsh

function catls() {
  [[ -f "$1" ]] && cat "$1" || ls "$1";
}
