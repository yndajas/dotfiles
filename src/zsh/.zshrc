#!/usr/bin/env zsh

## miscellaneous

# shellcheck disable=SC2034
# when moving between or deleting words, which (non-alphanumeric?) characters
# should be considered word-internal
WORDCHARS=''

# not sure what this is for. Can see reference to it in various Zsh plugin
# managers that I don't use
ZSH_CACHE_DIR="${HOME}/.zcache"
[[ -d "${ZSH_CACHE_DIR}" ]] || mkdir -p "${ZSH_CACHE_DIR}"

## shell programs (builtins and functions)

# needed before key bindings (and maybe thefuck - citation needed)
source "${HOME}/.config/zshrc/shell/completions.zsh"

source "${HOME}/.config/zshrc/shell/comments.zsh"
source "${HOME}/.config/zshrc/shell/history.zsh"
source "${HOME}/.config/zshrc/shell/key_bindings.zsh"
source "${HOME}/.config/zshrc/shell/pushd.zsh"

## system programs

source "${HOME}/.config/zshrc/system/less.zsh"
source "${HOME}/.config/zshrc/system/ssh.zsh"

## external programs

# needed before anything that relies on Homebrew-installed apps (probably)
source "${HOME}/.config/zshrc/external/homebrew.zsh"

# needed before loading zoxide so that _ZO_FZF_OPTS is in place
# (https://github.com/ajeetdsouza/zoxide#environment-variables)
source "${HOME}/.config/zshrc/external/fzf.zsh"

source "${HOME}/.config/zshrc/external/bat.zsh"
source "${HOME}/.config/zshrc/external/bun.zsh"
source "${HOME}/.config/zshrc/external/ls.zsh"
source "${HOME}/.config/zshrc/external/neovim.zsh"
source "${HOME}/.config/zshrc/external/nodenv.zsh"
source "${HOME}/.config/zshrc/external/pipx.zsh"
source "${HOME}/.config/zshrc/external/starship.zsh"
source "${HOME}/.config/zshrc/external/thefuck.zsh"
source "${HOME}/.config/zshrc/external/zgenom.zsh"
source "${HOME}/.config/zshrc/external/zoxide.zsh"

## self-written programs (functions)

# needed before any set_text_format
source "${HOME}/.config/zshrc/user/text_formatting.zsh"

source "${HOME}/.config/zshrc/user/dotfiles.zsh"
source "${HOME}/.config/zshrc/user/git.zsh"
source "${HOME}/.config/zshrc/user/hints.zsh"
source "${HOME}/.config/zshrc/user/homebrew.zsh"
source "${HOME}/.config/zshrc/user/manual.zsh"
source "${HOME}/.config/zshrc/user/shellcheck.zsh"

## local customisations (not backed up at github.com/yndajas/dotfiles)

[[ -f "${HOME}/.zshrc_local" ]] && source "${HOME}/.zshrc_local"

## various startup checks/echoes

warn_about_unsynced_dotfiles
warn_about_shellcheck_issues
hints random
