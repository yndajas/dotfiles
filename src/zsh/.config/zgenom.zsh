#!/usr/bin/env zsh

# shellcheck disable=SC2034
# used by zgenom
ZGEN_RESET_ON_CHANGE="${HOME}/.zshrc"
# shellcheck disable=SC2034
# used by zsh-syntax-highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
# shellcheck disable=SC2034
# used by autoupdate-zgenom
ZGEN_PLUGIN_UPDATE_DAYS=7
# shellcheck disable=SC2034
# used by autoupdate-zgenom
ZGEN_SYSTEM_UPDATE_DAYS=7

[[ -f "${HOME}/.zgenom/zgenom.zsh" ]] || git clone https://github.com/jandamm/zgenom.git "${HOME}/.zgenom"
source "${HOME}/.zgenom/zgenom.zsh"

if ! zgenom saved; then
  zgenom load djui/alias-tips
  zgenom load unixorn/autoupdate-zgenom
  zgenom load zsh-users/zsh-autosuggestions
  zgenom load zsh-users/zsh-completions
  zgenom load zsh-users/zsh-syntax-highlighting # Must be loaded before zsh-history-substring-search
  zgenom load zsh-users/zsh-history-substring-search

  zgenom save
fi
