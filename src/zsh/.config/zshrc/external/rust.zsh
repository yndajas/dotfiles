#!/usr/bin/env zsh

rustup_dir="$(brew --prefix rustup)"
path_excludes "${rustup_dir}/bin" && export PATH="${PATH}:${rustup_dir}/bin"
unset rustup_dir

path_excludes "${HOME}/.cargo/bin" && export PATH="${PATH}:${HOME}/.cargo/bin"
