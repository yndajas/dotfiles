#!/usr/bin/env zsh

HISTFILE="${HOME}/.histfile"
HISTSIZE=999999999
# shellcheck disable=SC2034
# Zsh-specific variable
SAVEHIST="${HISTSIZE}"

setopt extended_history
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt share_history
