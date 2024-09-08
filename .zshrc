# shellcheck disable=SC2148

if command_exists /opt/homebrew/bin/brew; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

HISTFILE=$HOME/.histfile
HISTSIZE=999999999
# shellcheck disable=SC2034
SAVEHIST=$HISTSIZE

# when moving between or deleting words, which (non-alphanumeric?) characters should be considered word-internal
# shellcheck disable=SC2034
WORDCHARS=''

ZSH_CACHE_DIR=$HOME/.zcache

if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir -p "$ZSH_CACHE_DIR"
fi

setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

setopt interactivecomments

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
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion::complete:*' use-cache true
zstyle ':completion::complete:*' cache-path "$ZSH_CACHE_DIR"

autoload -Uz compinit
compinit -i

if command_exists ssh-agent; then
  eval "$(ssh-agent)"
  ssh-add --apple-load-keychain
fi

# zgen settings
# shellcheck disable=SC2034
ZGEN_RESET_ON_CHANGE=$HOME/.zshrc

# zsh-syntax-highlighting settings
# shellcheck disable=SC2034
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# autoupdate-zgen settings
# shellcheck disable=SC2034
ZGEN_PLUGIN_UPDATE_DAYS=7
# shellcheck disable=SC2034
ZGEN_SYSTEM_UPDATE_DAYS=7

# Setup zgen
ZGEN_CLONE_DIR=$HOME/zgen
ZGEN_SCRIPT_PATH=$ZGEN_CLONE_DIR/zgen.zsh

if [[ ! -f $ZGEN_SCRIPT_PATH ]]; then
  git clone git@github.com:tarjoilija/zgen.git "$ZGEN_CLONE_DIR"
fi

# shellcheck source=/dev/null
source "$ZGEN_SCRIPT_PATH"

if ! zgen saved; then
  # zsh-users plugins
  zgen load zsh-users/zsh-autosuggestions
  zgen load zsh-users/zsh-completions
  zgen load zsh-users/zsh-syntax-highlighting # Must be loaded before zsh-history-substring-search
  zgen load zsh-users/zsh-history-substring-search

  # Other plugins
  zgen load djui/alias-tips
  zgen load unixorn/autoupdate-zgen

  zgen save
fi

if command_exists starship; then eval "$(starship init zsh)"; fi

if [[ -v ITERM_PROFILE ]]; then
  ITERM2_INTEGRATION_PATH=$HOME/.iterm2_shell_integration.zsh

  if [[ ! -f $ITERM2_INTEGRATION_PATH ]]; then
    curl -L https://iterm2.com/shell_integration/zsh -o "$ITERM2_INTEGRATION_PATH"
  fi

  # shellcheck source=/dev/null
  source "$ITERM2_INTEGRATION_PATH"
fi

if command_exists direnv; then eval "$(direnv hook zsh)"; fi
if command_exists rbenv; then eval "$(rbenv init -)"; fi
if command_exists nodenv; then eval "$(nodenv init -)"; fi

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

# use Emacs keybindings
# see "4.1.1: The simple facts" and "4.5.5: Keymaps" at https://zsh.sourceforge.io/Guide/zshguide04.html
bindkey -e
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

export EDITOR=nvim

# load aliases
source ~/.aliases.zsh

# ZSH tab completion for cheat.sh
# https://github.com/chubin/cheat.sh#zsh-tab-completion
fpath=(~/.zsh.d/ $fpath)

# bun completions
# See: https://github.com/oven-sh/bun/blob/267afa293483d5ed5f834a6d35350232188e3f98/docs/cli/bun-completions.md
[ -s "~/.bun/_bun" ] && source "~/.bun/_bun"

# command to clean up old git branches
# See: https://stackoverflow.com/questions/7726949/remove-tracking-branches-no-longer-on-remote/38404202#38404202
function clean_branches() {
  delete_flag="-d"

  while [ $# -gt 0 ]; do
    case $1 in
      --force) delete_flag="-D";;
    esac

    shift
  done

  git switch main && git fetch -p
  git branch -vv | awk '/: gone]/{print $1}' | xargs git branch $delete_flag
  git switch -
}

# fzf (fuzzy finder) setup
# this will also add a list to reverse-i-search (CTRL + R)
# fzf-git adds fzf git helpers, e.g. CTRL + G + H to list commit hashes
# See: https://github.com/junegunn/fzf-git.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh && source ~/.fzf-git.sh

## bat

# set bat theme
export BAT_THEME="OneHalfLight"

# use bat to add syntax highlighting to man
# see https://github.com/sharkdp/bat#man
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

dotfiles_dir="~/code/github.com/yndajas/dotfiles"

# keep Brewfile up to date
original_brew_command="$(which brew)"

function brew() {
  # just run brew if there are no arguments
  if [ $# -eq 0 ]; then
    eval ${original_brew_command} && return 0
  fi
  
  # otherwise run original brew command
  # and if that was successful and the first argument was install, uninstall,
  # remove, or rm, update the Brewfile
  eval ${original_brew_command} "$@" && if [[ "$1" == "install" || "$1" == "uninstall" || "$1" == "remove" || "$1" == "rm" || "$1" == "untap" ]]; then
    echo "\n==> Updating Brewfile"
    eval ${original_brew_command} bundle dump --file=${dotfiles_dir}/.Brewfile --describe --force --no-lock
  fi
}

# include local customisations (not backed up at github.com/yndajas/dotfiles)
if [ -f ~/.zshrc_local ]; then
    source ~/.zshrc_local
fi

# alert if dotfiles changes are not committed or pushed to remote
TEXT_BOLD='\033[1m'
TEXT_RED='\033[0;31m'
TEXT_RESET='\033[0m'

if output=$(git -C ~/code/github.com/yndajas/dotfiles status --porcelain) && [ -z "$output" ]; then
  if output=$(git -C ~/code/github.com/yndajas/dotfiles diff @{u}) && [ -z "$output" ]; then
  else
    echo -e "\n${TEXT_RED}${TEXT_BOLD}ALERT: unpushed changes in ~/code/github.com/yndajas/dotfiles${TEXT_RESET}"
  fi
else 
  echo -e "\n${TEXT_RED}${TEXT_BOLD}ALERT: uncommitted changes in ~/code/github.com/yndajas/dotfiles${TEXT_RESET}"
fi
