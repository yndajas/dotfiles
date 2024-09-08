# dotfiles

Dotfiles and other setup files for use across systems

## Setup

1. Clone this repo into `~/code/github.com/yndajas/dotfiles`
1. In Terminal, run `./install` from the cloned directory
1. Open iTerm2 and configure it:
    1. Open `Settings... > General > Settings`
    1. Check `Load settings from a custom folder or URL`
    1. Enter `~/.config/iterm2` in the text input
    1. Under `Save changes` choose `Automatically`
    1. Close the settings and current terminal window and open a new one
    1. If the settings don't appear to have loaded properly, try importing the profile in this repository into iTerm2 manually, quitting iTerm2, discarding any changes to the preferences iTerm2 has made, and finally reopening it
1. Install the following apps manually (to be automated later)
    - Fork
    - Xcode? (at least the command line tools)

## Maintenance

Most of the files contained in this repo are symlinked into the home directory (or another appropriate directory). Because of how symlinking works, changes will automatically be made directly in the cloned directory. `.zshrc` is set up to provide notifications of uncommited or unpushed changes.

If any new files need backing up, move them into the cloned directory and update `install.conf.yaml` to set up an appropriate symlink.

If any new install steps beyond symlinking files are required, add or update the shell sections in `install.conf.yaml`.

## Apps not currently in use

- Free Ruler
- Gapplin
- iTerm2
- Itsycal
