# shellcheck disable=SC2148

HISTFILE=$HOME/.histfile
HISTSIZE=999999999
# shellcheck disable=SC2034
SAVEHIST=$HISTSIZE

# when moving between or deleting words, which (non-alphanumeric?) characters should be considered word-internal
# shellcheck disable=SC2034
WORDCHARS=''

ZSH_CACHE_DIR=$HOME/.zcache

[[ -d $ZSH_CACHE_DIR ]] || mkdir -p "$ZSH_CACHE_DIR"

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

command_exists ssh-agent && eval "$(ssh-agent)" && ssh-add --apple-load-keychain

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

[[ -f $ZGEN_SCRIPT_PATH ]] || git clone git@github.com:tarjoilija/zgen.git "$ZGEN_CLONE_DIR"

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

source $HOME/.config/zsh/text_formatting.zsh # needed before any set_text_format
source $HOME/.config/zsh/homebrew.zsh

command_exists starship && eval "$(starship init zsh)"

# fzf (fuzzy finder) setup
# this will also add a list to reverse-i-search (CTRL + R)
# fzf-git adds fzf git helpers, e.g. CTRL + G + H to list commit hashes
# See: https://github.com/junegunn/fzf-git.sh
# this needs to run before zoxide init in order for _ZO_FZF_OPTS to affect the
# fzf preview (e.g. when running cd yndajas <TAB>)
[[ -f $HOME/.fzf.zsh ]] && source $HOME/.fzf.zsh && source $HOME/.fzf-git.sh

# I think these often ask to be run at the end of .zshrc. Zoxide mentions
# needing to run after compinit, which is run a little earlier in this file, and
# it also needs running before sources ~/.fzf.zsh so that _ZO_FZF_OPTS is set
# for custom fzf previews (e.g. when running cd yndajas <TAB>)
command_exists direnv && eval "$(direnv hook zsh)"
command_exists rbenv && eval "$(rbenv init -)"
command_exists nodenv && eval "$(nodenv init -)"
command_exists zoxide && eval "$(zoxide init zsh --cmd cd)"

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

# ZSH tab completion for cheat.sh
# https://github.com/chubin/cheat.sh#zsh-tab-completion
fpath=($HOME/.zsh.d/ $fpath)

# bun completions
# See: https://github.com/oven-sh/bun/blob/267afa293483d5ed5f834a6d35350232188e3f98/docs/cli/bun-completions.md
[[ -s $HOME/.bun/_bun ]] && source $HOME/.bun/_bun

source $HOME/.config/zsh/bat.zsh
source $HOME/.config/zsh/git.zsh
source $HOME/.config/zsh/ls.zsh
source $HOME/.config/zsh/man.zsh
source $HOME/.config/zsh/neovim.zsh

# include local customisations (not backed up at github.com/yndajas/dotfiles)
[[ -f $HOME/.zshrc_local ]] && source $HOME/.zshrc_local

# add local folder (where pipx apps are installed?) to path
export PATH="$PATH:$HOME/.local/bin"

source $HOME/.config/zsh/dotfiles.zsh

# echo random hint -------------------------------------------------------------
function random_hint() {
  # add functions
  local hints=(
    'aliases;lsrepo;Display git information within a repo'
    'aliases;lsrepos;Display git information within a directory of repos'
    'command line editing;Ctrl + K;Delete to end of line'
    'command line editing;Ctrl + U;Delete to start of line'
    'command line editing;Ctrl + W;Delete one word behind'
    'command line editing;Esc + D;Delete one word ahead'
    'command line navigation;Ctrl + A;Move cursor to the start of the line'
    'command line navigation;Ctrl + E;Move cursor to the end of the line'
    'command line navigation;Esc + A;Move cursor back one word'
    'command line navigation;Esc + F;Move cursor forward one word'
    'command line tools;clean_branches;Remove merged branches'
    'command line tools;in_every_repo_root [command];Execute the specified command in every repo'
    'command line tools;tldr [command];Community-sourced usage examples'
    'fuzzy find and git;Ctrl + G, (Ctrl +) B;View branches'
    'fuzzy find and git;Ctrl + G, (Ctrl +) E;git for-each-ref'
    'fuzzy find and git;Ctrl + G, (Ctrl +) F;View files'
    'fuzzy find and git;Ctrl + G, (Ctrl +) H;View commit hashes'
    'fuzzy find and git;Ctrl + G, (Ctrl +) L;View reflogs'
    'fuzzy find and git;Ctrl + G, (Ctrl +) R;View remotes'
    'fuzzy find and git;Ctrl + G, (Ctrl +) S;View stashes'
    'fuzzy find and git;Ctrl + G, (Ctrl +) T;View tags'
    'fuzzy find and git;Ctrl + G, (Ctrl +) W;View worktrees'
  )

  local seed=$$$(date +%s)
  local random_index=$(($seed % ${#hints[@]} + 1))
  local random_hint=${hints[$random_index]}

  local random_hint_items=(${(s/;/)random_hint})
  local category=${random_hint_items[1]}
  local command=${random_hint_items[2]}
  local explanation=${random_hint_items[3]}

  set_text_format --foreground cyan
  echo "A reminder about $category"
  set_text_format --reset
  echo "$explanation -> $command"
}

random_hint # ------------------------------------------------------------------

eval $(thefuck --alias)
