# Setup fzf
# ---------
path_excludes "/opt/homebrew/opt/fzf/bin" && \
  export PATH="${PATH}:/opt/homebrew/opt/fzf/bin"

# Auto-completion
# ---------------
source "/opt/homebrew/opt/fzf/shell/completion.zsh"

# Key bindings
# ------------
source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"

# Custom commands and options
# ------------
export FZF_DEFAULT_COMMAND="fd --strip-cwd-prefix --hidden --follow --exclude .git"
export FZF_DEFAULT_OPTS="
  --bind='ctrl-p:toggle-preview'
  --border-label-pos 0
  --border-label fzf
  --border rounded
  --color fg+:#1d1c25
  --color bg+:#d4d5f0
  --color hl:#be6bf7
  --color hl+:#be6bf7
  --color info:#636566
  --color label:#636566
  --color marker:#be6bf7
  --color pointer:#be6bf7
  --color prompt:#636566
  --marker '▸'
  --multi
  --preview-window border-rounded
  --reverse
  --separator ''
"

# command search
export FZF_CTRL_R_OPTS="
  --preview 'echo {}'
  --preview-window down:2:wrap
"

# file search
file_search_preview="bat --color=always"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND --type f"
export FZF_CTRL_T_OPTS="
  --no-height
  --preview '${file_search_preview} {}'
  --preview-window down:60%:~3
"

# directory search
directory_search_preview="eza --all --git-ignore --tree --level=2 --classify --color=always --icons=always --sort=type"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"
export FZF_ALT_C_OPTS="--preview '${directory_search_preview} {}'"

# ** search

## what search command to use

### for paths

_fzf_compgen_path() {
  fd --hidden --follow --exclude .git . "$1"
}

### for directories

_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude .git . "$1"
}

## how to preview based on preceding command

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    kill|unalias) fzf;;
    export|unset) fzf "$@" --preview "eval 'echo $'{}";;
    ssh)          fzf "$@" --preview "dig {}";;
    cd)           fzf "$@" --preview "${directory_search_preview} {}";;
    *)            fzf "$@" --no-height --preview "[ -f {} ] && ${file_search_preview} {} || ${directory_search_preview} {}" --preview-window down:60%:~3;;
  esac
}

# zoxide (cd yndajas <TAB>)
# this needs to run before zoxide init (https://github.com/ajeetdsouza/zoxide#environment-variables)
export _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS --delimiter ' ' --preview '${directory_search_preview} {2}'"
