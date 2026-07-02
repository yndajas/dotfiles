#!/usr/bin/env zsh

path_excludes "$(brew --prefix rustup)/bin" && export PATH="${PATH}:$(brew --prefix rustup)/bin"
path_excludes "${HOME}/.cargo/bin" && export PATH="${PATH}:${HOME}/.cargo/bin"
