#!/usr/bin/env zsh

# cat -> bat

alias cat="bat"

# directories/paths
# zoxide is aliased to cd using `zoxide init zsh --cmd cd` in .zshrc

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

# ls -> eza

alias ls="eza --all --classify --color=always --icons=always --sort=type"
alias lsrepo="eza --all --git-ignore --long --git --no-filesize --no-permissions --no-time --no-user --classify --color=always --icons=always --sort=type"
alias lsrepos="eza --long --git-repos --no-filesize --no-permissions --no-time --no-user --classify --color=always --icons=always --sort=type"

# vim -> nvim

alias vim="nvim"
