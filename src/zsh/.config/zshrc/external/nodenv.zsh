#!/usr/bin/env zsh

[[ -z "${TMUX}" ]] && command_exists nodenv && eval "$(nodenv init -)"
