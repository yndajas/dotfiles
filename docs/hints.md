# Hints

Reminders about tools and key bindings. Entries marked "homegrown" are defined
in this repository.

## Docker

- Kill all containers: `docker kill $(docker ps -q)`
- Remove all containers: `docker rm $(docker ps -a -q)`
- Remove all volumes: `docker volume rm $(docker volume ls -q)`
- Remove all images: `docker rmi $(docker images -q)`
- Remove unused data: `docker system prune -a`
- Remove temporary or cached Docker Scout data: `docker scout cache prune`
- Remove build cache (see also: docker builder rm): `docker builder prune`
- Remove orphaned containers (not defined in Compose file):
  `docker-compose down --remove-orphans`

## Documentation

- Community-sourced usage examples: `tldr <command>`

## Environment

- Manage dotfiles: `dotfiles [<command>]` (homegrown)

## Git

- Display git information within a directory of repositories: `lsrepos`
  (homegrown)
- Display git information within a repository: `lsrepo` (homegrown)
- Execute the specified command in every repo: `in_every_repo_root <command>`
  (homegrown)
- Remove merged branches: `clean_branches` (homegrown)
- Explore branches: `Ctrl + G, (Ctrl +) B`
- Explore commit hashes: `Ctrl + G, (Ctrl +) H`
- Explore files: `Ctrl + G, (Ctrl +) F`
- Explore reflogs: `Ctrl + G, (Ctrl +) L`
- Explore remotes: `Ctrl + G, (Ctrl +) R`
- Explore stashes: `Ctrl + G, (Ctrl +) S`
- Explore tags: `Ctrl + G, (Ctrl +) T`
- Explore worktrees: `Ctrl + G, (Ctrl +) W`
- git for-each-ref: `Ctrl + G, (Ctrl +) E`
- Bring any git submodules up-to-date with their remote:
  `git submodule update --remote`

## Neovim

- Blame current buffer: `:Gitsigns blame`
- Blame current line: `:Gitsigns blame_line`
- Repeat the last command line command (via registers). Works in visual line
  mode so you can repeat an action like LSP quick fixes across multiple lines:
  `@@` or `@:`
- Fix spelling (:h ins-completion): `Ctrl-x s` (insert mode)
- Go to previous misspelled word: `[ s`
- Go to next misspelled word: `] s`
- Go back a location: `Ctrl-o`
- Go forward a location (after going back): `Ctrl-i`

## tmux

- Open hyperlink under cursor: `Cmd + Shift + click` (homegrown)
- Open visible links in fzf, then select one to open in the default browser:
  `Ctrl-a O` (homegrown)
