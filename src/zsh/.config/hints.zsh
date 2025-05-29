#!/usr/bin/env zsh

hints=(
  'aliases;lsrepo;Display git information within a repo'
  'aliases;lsrepos;Display git information within a directory of repos'
  'command line editing;Ctrl + K;Delete to end of line'
  'command line editing;Ctrl + U;Delete to start of line'
  'command line editing;Ctrl + W;Delete one word behind'
  'command line editing;Esc + D;Delete one word ahead'
  'command line navigation;Ctrl + A;Move cursor to the start of the line'
  'command line navigation;Ctrl + E;Move cursor to the end of the line'
  'command line navigation;Option + Left (or Esc + B);Move cursor back one word'
  'command line navigation;Option + Right (or Esc + F);Move cursor forward one word'
  'command line tools;clean_branches;Remove merged branches'
  'command line tools;in_every_repo_root [command];Execute the specified command in every repo'
  'command line tools;tldr [command];Community-sourced usage examples'
  'fuzzy find and git;Ctrl + G, (Ctrl +) B;View branches'
  'fuzzy find and git;Ctrl + G, (Ctrl +) E;git for-each-ref'
  'fuzzy find and git;Ctrl + G, (Ctrl +) F;View files'
  'fuzzy find and git;Ctrl + G, (Ctrl +) H;View commit hashes'
  'fuzzy find and git;Ctrl + G, (Ctrl +) L;View reflogs'
  'fuzzy find and git;Ctrl + G, (Ctrl +) R;View remotes'
  'fuzzy find and git;Ctrl + G, (Ctrl +) S;View stashes'
  'fuzzy find and git;Ctrl + G, (Ctrl +) T;View tags'
  'fuzzy find and git;Ctrl + G, (Ctrl +) W;View worktrees'
)

function random_hint() {
  # add functions
  # add normal fuzzy find - reverse-i-search (CTRL + R), cd yndajas <TAB>, CTRL + T, some others
  # add curl cht.sh (https://github.com/chubin/cheat.sh) - consider installing it
  local seed=$$$(date +%s)
  local random_index=$(($seed % ${#hints[@]} + 1))
  local random_hint=${hints[$random_index]}

  local random_hint_items=(${(s/;/)random_hint})
  local category=${random_hint_items[1]}
  local command=${random_hint_items[2]}
  local explanation=${random_hint_items[3]}

  set_text_format --foreground cyan
  echo "A reminder about $category"
  set_text_format --reset
  echo "$explanation -> $command"
}
