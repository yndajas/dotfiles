#!/usr/bin/env zsh

# add local folder (where pipx apps are installed?) to path
[[ -z "${TMUX}" ]] && export PATH="${PATH}:${HOME}/.local/bin"
