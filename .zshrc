# Powerlevel10k theme

## Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
## Initialization code that may require console input (password prompts, [y/n]
## confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

## load theme
source ~/powerlevel10k/powerlevel10k.zsh-theme

## To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# highlighting and autocomplete

source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

## zsh-completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi


# load aliases
source ~/.aliases


# commands
addssh() {
  ssh-add --apple-use-keychain ~/.ssh/id_ed25519
}


# set iTerm2 tab title
if [ $ITERM_SESSION_ID ]; then
precmd() {
  echo -ne "\033]0;${PWD##*/}\007"
}
fi


# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# homebrew

## add Intel compatibility version
export PATH="/usr/local/bin:$PATH"

## add ARM/M1 compatibility version
export PATH="/opt/homebrew/bin:$PATH"


# husky

## makes it work with Sourcetree
echo "export PATH="$(dirname $(which node)):$PATH"" > ~/.huskyrc


# rvm

## Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
