# dotfiles

Dotfiles and other setup files for use across systems

## Setup

1. Clone this repo into `${HOME}/code/github.com/yndajas/dotfiles`
1. In Terminal, run `./install` from the cloned directory
1. Install Xcode (at least the command line tools) manually (to be automated
   later)?
1. Add WakaTime API keys to VS Code and Neovim

## Maintenance

Most of the files contained in this repo are symlinked into the home directory
(or another appropriate directory). Because of how symlinking works, changes
will automatically be made directly in the cloned directory. `.zshrc` is set up
to provide notifications of uncommited or unpushed changes.

If any new files need backing up, move them into the cloned directory and update
`install.conf.yaml` to set up an appropriate symlink.

If any new install steps beyond symlinking files are required, add or update the
shell sections in `install.conf.yaml`.
