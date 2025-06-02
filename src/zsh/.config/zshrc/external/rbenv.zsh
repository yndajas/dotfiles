#!/usr/bin/env zsh

[[ -z "${TMUX}" ]] && command_exists rbenv && eval "$(rbenv init -)"
