# START local-env (dxw)

# shellcheck disable=SC2148

if [[ "$(uname -m)" == "arm64" ]] || [[ "$(sysctl -in sysctl.proc_translated)" == "1" ]]; then
  if command -v /usr/local/bin/brew >/dev/null 2>&1; then
    eval "$(/usr/local/bin/brew shellenv)"
    FPATH=$(/usr/local/bin/brew --prefix)/share/zsh/site-functions:$FPATH
    alias ibrew='arch -x86_64 /usr/local/bin/brew'
  fi

  if command -v /opt/homebrew/bin/brew >/dev/null 2>&1; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    FPATH=$(/opt/homebrew/bin/brew --prefix)/share/zsh/site-functions:$FPATH
  fi
else
  if command -v /usr/local/bin/brew >/dev/null 2>&1; then
    eval "$(/usr/local/bin/brew shellenv)"
    FPATH=$(/usr/local/bin/brew --prefix)/share/zsh/site-functions:$FPATH
  fi
fi

HISTFILE=$HOME/.histfile
HISTSIZE=999999999
# shellcheck disable=SC2034
SAVEHIST=$HISTSIZE

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

if command -v ssh-agent >/dev/null 2>&1; then
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

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

if [[ -v ITERM_PROFILE ]]; then
  ITERM2_INTEGRATION_PATH=$HOME/.iterm2_shell_integration.zsh

  if [[ ! -f $ITERM2_INTEGRATION_PATH ]]; then
    curl -L https://iterm2.com/shell_integration/zsh -o "$ITERM2_INTEGRATION_PATH"
  fi

  # shellcheck source=/dev/null
  source "$ITERM2_INTEGRATION_PATH"
fi

if command -v direnv > /dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

if command -v rbenv >/dev/null 2>&1; then
  eval "$(rbenv init -)"
fi

if command -v nodenv >/dev/null 2>&1; then
  eval "$(nodenv init -)"
fi

if command -v phpenv >/dev/null 2>&1; then
  eval "$(phpenv init -)"
fi

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

function take() {
  mkdir -p "$@" && cd "${@:$#}" || exit 1
}

bindkey -e

bindkey -M menuselect '^o' accept-and-infer-next-history

# zsh-history-substring-search key bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Ynda edited from export EDITOR=nano
export EDITOR=nvim

# END local-env (dxw)

# load aliases
source ~/.aliases

# ZSH tab completion for cheat.sh
# https://github.com/chubin/cheat.sh#zsh-tab-completion
fpath=(~/.zsh.d/ $fpath)

# bun completions
[ -s "/Users/yndajas/.bun/_bun" ] && source "/Users/yndajas/.bun/_bun"

# command to clean up old git branches
# See: https://stackoverflow.com/questions/7726949/remove-tracking-branches-no-longer-on-remote/38404202#38404202
function clean_branches() {
  FORCE=false

  for arg in "$@"
  do
    if [[ $arg == "--force" ]]; then
      FORCE=true
    fi
  done

  git switch main && git fetch -p

  if [ "$FORCE" = true ]; then
    git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -D
  else
    git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -d
  fi

  git switch -
}

# fzf (fuzzy finder) setup
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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
  echo -e "\n${TEXT_RED}${TEXT_BOLD}ALERT: uncommited changes in ~/code/github.com/yndajas/dotfiles${TEXT_RESET}"
fi
