#!/usr/bin/env zsh

function path_includes() {
  [[ $# -eq 0 ]] && return 1

  while [[ $# -gt 0 ]]; do
    [[ ":${PATH}:" != *":${1}:"* ]] && return 1
    shift
  done
}

function path_excludes() {
  [[ $# -eq 0 ]] && return 1

  while [[ $# -gt 0 ]]; do
    [[ ":${PATH}:" == *":${1}:"* ]] && return 1
    shift
  done
}
