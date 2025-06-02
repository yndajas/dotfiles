#!/usr/bin/env zsh

# Vi(m) keybindings
# (https://zsh.sourceforge.io/Guide/zshguide04.html#:~:text=4.1.1%3A%20The%20simple%20facts)
# (https://zsh.sourceforge.io/Guide/zshguide04.html#:~:text=4.5.5%3A%20Keymaps)
bindkey -v '^?' backward-delete-char '\e[3~' delete-char

# Ctrl + O -> accept current menu selection and try completion with menu
# selection again
# (https://zsh.sourceforge.io/Guide/zshguide04.html#:~:text=4.4.1%3A%20Moving%20through%20the%20history)
bindkey -M menuselect '^o' accept-and-infer-next-history
# shellcheck disable=SC2034
# makes moving between Vi insert and command/normal mode quicker but might have
# trade offs/break certain things
# (https://superuser.com/a/648046/1070357)
# (https://www.johnhawthorn.com/2012/09/vi-escape-delays)
# (https://github.com/jeffreytse/zsh-vi-mode)
KEYTIMEOUT=1
