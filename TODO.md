# TODO

- Namespace custom git functions
- Consider nvim extensions:
  - https://github.com/gbprod/yanky.nvim
  - https://github.com/alexandre-abrioux/blink-cmp-npm.nvim
  - https://github.com/mikavilpas/blink-ripgrep.nvim
  - https://github.com/niuiic/blink-cmp-rg.nvim
  - https://github.com/netmute/ctags-lsp.nvim
  - https://github.com/archie-judd/blink-cmp-words (vs blink-cmp-dictionary, it
    also has a thesaurus)
- restructure lua/plugins/*.lua to lua/plugins/<org>/<repo>.lua
- Add Raycast config?
- Add commands for finding open localhost ports somewhere:
  - find listening ports `lsof -i -n -P | grep '(LISTEN)'`
  - find Ruby ports `lsof -i -n -P | grep 'ruby'`
  - find ports in use by Ruby and associated processes (Ruby could be
    substituted with something else found by the first command above, perhaps
    via a function argument): `echo -e "ports in use by Ruby processes (lsof) followed by process IDs, uptime, and commands (ps)\n" && lsof -i -P -n | grep 'ruby' | tee > >(awk '{print $9}' | grep --only-matching --extended-regexp "\d+$" | sort | uniq) >(awk '{print $2}' | uniq | xargs -I {} ps {} -o pid=,time=,comm=)`
- Copy glow.json from Advent of Code repo to this repo (symlinked)
- Check out Helix some more; symlink in dotfiles repo if useful, uninstall if
  not
- Shift functions to executable script files added to path? <https://youtu.be/D2pe9ZZ2yCE>
- transfer tabs from Arc and mobile browsers to somewhere else
- unset variables outside functions that aren't needed permanently?
- Add more Mac App Store apps to Brewfile? Or is it auto-populated?
- Move relevant ~/.config/ files into repo
- Add to hints array
  - Vim: splits (:sp), tabs (:tabnew or maybe :new), forward search current word
    (*, then n or N to go next or previous), backward search current word (£,
    then the same), redo (.), visual block mode (Ctrl + V, then use keys to
    select multiple lines, then Ctrl + I to go to the start of the first, do
    something, then Esc to apply to the start of each)
  - custom functions like clean_branches and random_hint
  - man readline view navigation keys
  - ~command~ \*\* fuzzy find
  - Ctrl + T fuzzy find files
  - Esc + C fuzzy find directories
  - Ctrl + R fuzzy find commands
  - glow Markdown pager
  - gh
  - zsh-git
  - jq
  - Zoxide
  - <https://gist.github.com/acamino/2bc8df5e2ed0f99ddbe7a6fddb7773a6> (check
    these are all valid in my terminal)
  - what the Starship git symbols mean
  - Ctrl + O accept highlighted suggestion from menu and provide next set of
    suggestions (useful for directory navigation when using cd; set in .zshrc
    with `bindkey -M menuselect '^o' accept-and-infer-next-history`)
  - up and down to navigate zsh (auto?)completion suggestions, going through
    historical matching commands (set in .zshrc with
    `bindkey '^[[A' history-substring-search-up` and
    `bindkey '^[[B' history-substring-search-down`))
  - cheat.sh
  - difference between .zshrc, .zshenv and others:
    <https://unix.stackexchange.com/a/487889/639529>
  - conditional expressions and their flags in Zsh:
    <https://zsh.sourceforge.io/Doc/Release/Conditional-Expressions.html#Conditional-Expressions>
- Add bat config file (e.g. to set the theme default without adding an
  environment variable): <https://github.com/sharkdp/bat#configuration-file>
- Add bat extras? <https://github.com/eth-p/bat-extras>
- Set up Ripgrep with fzf to search inside files:
  <https://github.com/junegunn/fzf/blob/master/ADVANCED.md#ripgrep-integration>
- Add `ls **` fzf command that sets `fd --type d`:
  <https://github.com/junegunn/fzf/tree/master?tab=readme-ov-file#custom-fuzzy-completion>
- Add command line tools setup step
- Echo random reminder/TODO on .zshrc
  - Continue reading through The Rust Programming Language
  - Continue with exercises at code/github.com/rust-lang/rustlings
  - Learn Go
  - Read No Starch Press programming books (Books app)
  - Check out Destroy All Software/Execute Program
  - Check out Frontend Masters
  - Japanese learning: WaniKani, BunPro etc
- Make some TUIs?
