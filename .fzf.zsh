# Setup fzf
# ---------
if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
fi

# Auto-completion
# ---------------
source "/opt/homebrew/opt/fzf/shell/completion.zsh"

# Key bindings
# ------------
source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"

# Custom commands and options
# ------------
# respect .gitignore in CTRL + T/fzf
export FZF_DEFAULT_COMMAND="fd --type f --strip-cwd-prefix --hidden --follow --exclude .git"
FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export FZF_DEFAULT_OPTS="--multi --bind='ctrl-p:toggle-preview'"

# show preview window when searching for files using CTRL + T
export FZF_CTRL_T_OPTS="--no-height --preview 'bat --color=always {}' --preview-window up:60%:~3"

# add wrapped preview of full command
# useful if the command is too long to be shown in the list unwrapped
export FZF_CTRL_R_OPTS="--reverse --preview 'echo {}' --preview-window down:2:wrap"
