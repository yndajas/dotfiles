#!/usr/bin/env zsh

# shellcheck disable=SC2034
# used by zgenom
ZGEN_RESET_ON_CHANGE="${HOME}/.config/zshrc/external/zgenom.zsh"
# shellcheck disable=SC2034
# used by zsh-syntax-highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
# shellcheck disable=SC2034
# used by autoupdate-zgenom
ZGEN_PLUGIN_UPDATE_DAYS=7
# shellcheck disable=SC2034
# used by autoupdate-zgenom
ZGEN_SYSTEM_UPDATE_DAYS=7

if [[ ! -f "${HOME}/code/github.com/jandamm/zgenom/zgenom.zsh" ]]; then
  mkdir -p "${HOME}/code/github.com/jandamm"
  git clone https://github.com/jandamm/zgenom.git "${HOME}/code/github.com/jandamm/zgenom"
fi

source "${HOME}/code/github.com/jandamm/zgenom/zgenom.zsh"

if ! zgenom saved; then
  zgenom load djui/alias-tips
  zgenom load unixorn/autoupdate-zgenom
  zgenom load zsh-users/zsh-autosuggestions
  zgenom load zsh-users/zsh-completions
  # needs loading before zsh-history-substring-search
  # (https://github.com/zsh-users/zsh-history-substring-search)
  zgenom load zsh-users/zsh-syntax-highlighting
  zgenom load zsh-users/zsh-history-substring-search

  zgenom save
fi

# up/down support for navigating command history
# needs to go after loading zsh-users/zsh-history-substring-search
# (https://github.com/zsh-users/zsh-history-substring-search)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
