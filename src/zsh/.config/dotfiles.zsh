#!/usr/bin/env zsh

# open dotfiles in VSCode by default or optionally specify whether you want to
# do that and/or change directory ----------------------------------------------
function dotfiles() {
  [[ $# -eq 0 ]] && code $DOTFILES_DIR

  while [[ $# -gt 0 ]]; do
    case $1 in
      --cd) cd $DOTFILES_DIR;;
      --code) code $DOTFILES_DIR;;
    esac

    shift
  done
} # ----------------------------------------------------------------------------

function install_dotfiles() {
  eval $DOTFILES_DIR/install
}

# alert if dotfiles changes are not committed or pushed to remote --------------
source $HOME/.config/zsh/text_formatting.zsh

if [[ -n "$(eval git -C $DOTFILES_DIR status --porcelain)" ]]; then
  set_text_format --foreground red
  echo "Warning: uncommitted changes in $DOTFILES_DIR"
else
  if [[ -n "$(eval git -C $DOTFILES_DIR diff @{u})" ]]; then
    set_text_format --foreground red
    echo "Warning: unpushed changes in $DOTFILES_DIR"
  fi
fi # ---------------------------------------------------------------------------
