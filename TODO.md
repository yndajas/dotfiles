# TODO

- Add more Mac App Store apps to Brewfile? Or is it auto-populated?
- Move relevant ~/.config/ files into repo
- Add to hints array
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
  - Read No Starch Press progamming books (Books app)
  - Check out Destroy All Software/Execute Program
  - Check out Frontend Masters
  - Japanese learning: WaniKani, BunPro etc
- Make some TUIs?
