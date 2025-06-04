#!/usr/bin/env zsh

# add local folder (where pipx apps are installed?) to path
path_excludes "${HOME}/.local/bin" && export PATH="${PATH}:${HOME}/.local/bin"
