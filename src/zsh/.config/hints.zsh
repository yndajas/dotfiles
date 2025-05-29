#!/usr/bin/env zsh

# TO ADD
# functions
# normal fuzzy find - reverse-i-search (CTRL + R), cd yndajas <TAB>, CTRL + T, some others
# curl cht.sh (https://github.com/chubin/cheat.sh) - consider installing it

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
  'hints;all_hints;Show all hints'
)

function print_hint() {
  [[ $# -ne 1 ]] && return 1

  local hint=$hints[$1]
  local components=(${(s/;/)hint})
  local category=$components[1]
  local command=$components[2]
  local explanation=$components[3]

  set_text_format --foreground cyan
  echo "A reminder about $category"
  set_text_format --reset
  echo -n "$explanation -> "
  set_text_format --bold
  echo $command
}

function random_hint() {
  local seed=$$$(date +%s)
  local random_index=$(( $seed % $#hints[@] + 1 ))
  print_hint $random_index
}

function all_hints() {
  local formatted_hints=""
  for index in $(seq 1 $#hints[@])
  do
    formatted_hints+=`print_hint $index`
    [[ $index -ne $#hints[@] ]] && formatted_hints+="\n\n"
  done
  echo "$formatted_hints[@]"
}
