#!/usr/bin/env zsh

function dotfiles() {
  local command=''
  local valid_commands=(cd code install)
  local usage_text="usage: dotfiles <command>

Commands:
   cd         change into the directory of the dotfiles repository
   code       open the dotfiles repository in VS Code
   install    (re)install the dotfiles (idempotent)"

  [[ $# -gt 1 ]] && echo $usage_text && return 1

  if [[ $# -eq 1 ]]; then
    (( $valid_commands[(Ie)$1] )) && command=$1 || { echo $usage_text && return 1 }
  fi

  while ! (( $valid_commands[(Ie)$command] )); do
    vared -p 'Enter command (cd/code/install): ' command
  done

  case $command in
    cd) cd $DOTFILES_DIR;;
    code) code $DOTFILES_DIR;;
    install) eval $DOTFILES_DIR/install;;
  esac
}

# alert if dotfiles changes are not committed or pushed to remote
source $HOME/.config/zsh/text_formatting.zsh
if [[ -n "$(eval git -C $DOTFILES_DIR status --porcelain)" ]]; then
  set_text_format --foreground red
  echo "Warning: uncommitted changes in $DOTFILES_DIR"
elif [[ -n "$(eval git -C $DOTFILES_DIR diff @{u})" ]]; then
  set_text_format --foreground red
  echo "Warning: unpushed changes in $DOTFILES_DIR"
fi
