#!/usr/bin/env zsh

# cat -> bat

alias cat="bat"

# directories/paths
# zoxide is aliased to cd using `zoxide init zsh --cmd cd` in .zshrc

# ls -> eza

alias ls="eza --all --classify --color=always --icons=always --sort=type"
alias lsrepo="eza --all --git-ignore --long --git --no-filesize --no-permissions --no-time --no-user --classify --color=always --icons=always --sort=type"
alias lsrepos="eza --long --git-repos --no-filesize --no-permissions --no-time --no-user --classify --color=always --icons=always --sort=type"

# vim -> nvim

alias vim="nvim"
