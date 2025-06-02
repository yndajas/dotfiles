#!/usr/bin/env zsh

HISTFILE="${HOME}/.histfile"
HISTSIZE=999999999
# shellcheck disable=SC2034
# Zsh-specific variable
SAVEHIST="${HISTSIZE}"

# shellcheck disable=SC2034
# when moving between or deleting words, which (non-alphanumeric?) characters
# should be considered word-internal
WORDCHARS=''

# shellcheck disable=SC2034
# used by ZLE. Makes moving between Vi insert and command/normal mode quicker
# but might have trade offs/break certain things
# (https://superuser.com/a/648046/1070357)
# (https://www.johnhawthorn.com/2012/09/vi-escape-delays)
# (https://github.com/jeffreytse/zsh-vi-mode)
KEYTIMEOUT=1

ZSH_CACHE_DIR="${HOME}/.zcache"
[[ -d "${ZSH_CACHE_DIR}" ]] || mkdir -p "${ZSH_CACHE_DIR}"

setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

setopt interactivecomments

setopt extended_history
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt share_history

setopt always_to_end
setopt auto_menu
setopt complete_in_word
unsetopt flowcontrol
unsetopt menu_complete

zmodload -i zsh/complist

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u ${USER} -o pid,user,comm -w -w"
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion::complete:*' use-cache true
zstyle ':completion::complete:*' cache-path "${ZSH_CACHE_DIR}"

autoload -Uz compinit
compinit -i

command_exists ssh-agent && \
  eval "$(ssh-agent)" > /dev/null && ssh-add -q --apple-load-keychain

# use Vim keybindings
# see "4.1.1: The simple facts" and "4.5.5: Keymaps" at https://zsh.sourceforge.io/Guide/zshguide04.html
bindkey -v '^?' backward-delete-char '\e[3~' delete-char

# Ctrl + O -> accept current menu selection and try completion with menu selection again
# see "4.4.1: Moving through the history" at https://zsh.sourceforge.io/Guide/zshguide04.html
# see https://github.com/zsh-users/zsh/blob/6b9704e2c4e4c8524137a9c15bf9b166a975f3eb/Doc/Zsh/mod_complist.yo#L318-L326
bindkey -M menuselect '^o' accept-and-infer-next-history
# Up -> move up through historical commands in completion
# see https://github.com/zsh-users/zsh-history-substring-search
bindkey '^[[A' history-substring-search-up
# Down -> move down through historical commands in completion
# see https://github.com/zsh-users/zsh-history-substring-search
bindkey '^[[B' history-substring-search-down

source "${HOME}/.config/zsh/zgenom.zsh"

# probably needs to come before anything that relies on Homebrew-installed apps
source "${HOME}/.config/zsh/homebrew.zsh"

# bun completions (https://github.com/oven-sh/bun/blob/main/docs/cli/bun-completions.md)
[[ -s "${HOME}/.bun/_bun" ]] && source "${HOME}/.bun/_bun"
# needs to run before zoxide init because it contains the _ZO_FZF_OPTS
# environment variable (https://github.com/ajeetdsouza/zoxide#environment-variables)
[[ -f "${HOME}/.fzf.zsh" ]] && source "${HOME}/.fzf.zsh" && source "${HOME}/.fzf-git.sh"

[[ -z "${TMUX}" ]] && command_exists nodenv && eval "$(nodenv init -)"
[[ -z "${TMUX}" ]] && command_exists rbenv && eval "$(rbenv init -)"
command_exists starship && { type starship_zle-keymap-select > /dev/null || eval "$(starship init zsh)"; }
# needs to run after compinit (https://github.com/ajeetdsouza/zoxide#installation)
command_exists thefuck && eval "$(thefuck --alias)"
command_exists zoxide && eval "$(zoxide init zsh --cmd cd)"

source "${HOME}/.config/zsh/text_formatting.zsh" # needed before any set_text_format
source "${HOME}/.config/zsh/bat.zsh"
source "${HOME}/.config/zsh/dotfiles.zsh"
source "${HOME}/.config/zsh/git.zsh"
source "${HOME}/.config/zsh/hints.zsh"
source "${HOME}/.config/zsh/less.zsh"
source "${HOME}/.config/zsh/ls.zsh"
source "${HOME}/.config/zsh/man.zsh"
source "${HOME}/.config/zsh/neovim.zsh"
source "${HOME}/.config/zsh/pipx.zsh"
source "${HOME}/.config/zsh/shellcheck.zsh"

# local customisations (not backed up at github.com/yndajas/dotfiles)
[[ -f "${HOME}/.zshrc_local" ]] && source "${HOME}/.zshrc_local"

hints random
