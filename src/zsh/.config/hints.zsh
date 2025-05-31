#!/usr/bin/env zsh

# TO ADD
# functions
# normal fuzzy find - reverse-i-search (CTRL + R), cd yndajas <TAB>, CTRL + T, some others
# curl cht.sh (https://github.com/chubin/cheat.sh) - consider installing it
# Vim Ctrl + C or Ctrl + [ (as well as Esc) to exit insert mode (Ctrl + [ or Esc only in Zsh/ZLE, or maybe just Esc? Option + Up or Option + Down)
# manual instead of man
# ZLE Vim dia to delete entirety of current word (including character under cursor) https://www.reddit.com/r/zsh/comments/r42xo4/comment/hme8k0h/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
# Caps lock is now control
# tmux copy mode: https://man.openbsd.org/tmux#WINDOWS_AND_PANES
# tmux open url: Shift + Cmd + Click

HINTS_PATH=$HOME/.config/zsh/hints.json

function add_hint() {
  local category=''
  local hint=''
  local explanation=''
  local homegrown=''

  while [[ -z $category ]]; do vared -p 'Enter a category: ' category; done
  while [[ -z $hint ]]; do vared -p 'Enter the hint: ' hint; done
  while [[ -z $explanation ]]; do vared -p 'Enter an explanation: ' explanation; done

  local valid_homegrown_responses=(y yes n no)
  while ! (( $valid_homegrown_responses[(Ie)$homegrown] )); do vared -p 'Is it homegrown (y[es]/n[o])? ' homegrown; done
  case $homegrown in
    y|yes) homegrown=true;;
    n|no) homegrown=false;;
  esac

  # local new_hint="{
  #   \"explanation\": \"$explanation\",
  #   \"hint\": \"$hint\",
  #   \"homegrown\": $homegrown
  # }"

  local current_json=$(cat $HINTS_PATH)
  echo $current_json | jq --arg category $category \
     --arg explanation $explanation \
     --arg hint $hint \
     --argjson homegrown "$homegrown" \
     '.[$category] = (
        .[$category] + [{
          explanation: $explanation,
          hint: $hint,
          homegrown: $homegrown
        }] |
        del(.. | nulls)
     )' > $HINTS_PATH
}

function random_hint() {
  local seed=$$$(date +%s)

  local category_count=$(jq 'keys | length' $HINTS_PATH)
  local category_key_index=$(( $seed % $category_count ))
  local category=$(jq -r "keys[$category_key_index]" $HINTS_PATH)

  local item_count=$(jq ".\"$category\" | length" $HINTS_PATH)
  local item_index=$(( $seed % $item_count ))
  local item=$(jq -r ".\"$category\"[$item_index]" $HINTS_PATH)

  local hint=$(echo $item | jq -r '.hint')
  local explanation=$(echo $item | jq -r '.explanation')
  local homegrown=$(echo $item | jq -r '.homegrown')

  local formatted_hint=""
  formatted_hint+=`set_text_format --foreground cyan`
  formatted_hint+="A reminder about $category\n"
  formatted_hint+=`set_text_format --reset`
  formatted_hint+="$explanation -> "
  formatted_hint+=`set_text_format --bold`
  formatted_hint+=$hint
  if [[ $homegrown == 'true' ]]; then
    formatted_hint+=`set_text_format --foreground white`
    formatted_hint+=' (homegrown)'
  fi

  echo $formatted_hint
}

function all_hints() {
  while [[ $# -gt 0 ]]; do
    case $1 in
      --homegrown) local homegrown_only='true'; shift;;
      *) return 1;;
    esac
  done

  local formatted_hints=""
  local category_count=$(jq 'keys | length' $HINTS_PATH)

  for category_key_index in $(seq 0 $(( $category_count - 1 )))
  do
    local category=$(jq -r "keys[$category_key_index]" $HINTS_PATH)
    [[ $homegrown_only == 'true' ]] && \
      [[ $(jq ".\"$category\" | map(select(.homegrown)) | length" $HINTS_PATH) -eq 0 ]] && \
      continue
    formatted_hints+=`set_text_format --foreground cyan`
    formatted_hints+="Reminders about $category\n"

    local item_count=$(jq ".\"$category\" | length" $HINTS_PATH)

    for item_index in $(seq 0 $(( $item_count - 1 )))
    do
      local item=$(jq -r ".\"$category\"[$item_index]" $HINTS_PATH)
      local homegrown=$(echo $item | jq -r '.homegrown')
      [[ $homegrown_only == 'true' ]] && [[ $homegrown != 'true' ]] && continue
      local hint=$(echo $item | jq -r '.hint')
      local explanation=$(echo $item | jq -r '.explanation')

      formatted_hints+=`set_text_format --reset`
      formatted_hints+="$explanation -> "
      formatted_hints+=`set_text_format --bold`
      formatted_hints+=$hint
      if [[ $homegrown == 'true' ]]; then
        formatted_hints+=`set_text_format --foreground white`
        formatted_hints+=' (homegrown)'
      fi
      formatted_hints+="\n"
    done

    [[ $category_key_index -lt $(( $category_count - 1 )) ]] && formatted_hints+="\n"
  done

  echo "$formatted_hints" | cat
}

function hint_categories() {
  jq -r 'keys[]' $HINTS_PATH
}

function hints() {
  local command=''
  local valid_commands=(add categories homegrown list random)
  local usage_text="usage: hints <command>

Commands:
   add        add a hint interactively
   categories list existing hint categories
   homegrown  display homegrown hints
   list       display all hints
   random     display a random hint"

  [[ $# -gt 1 ]] && echo $usage_text && return 1

  if [[ $# -eq 1 ]]; then
    (( $valid_commands[(Ie)$1] )) && command=$1 || { echo $usage_text && return 1 }
  fi

  while ! (( $valid_commands[(Ie)$command] )); do
    vared -p 'Enter command (add/categories/homegrown/list/random): ' command
  done

  case $command in
    add) add_hint;;
    categories) hint_categories;;
    homegrown) all_hints --homegrown;;
    list) all_hints;;
    random) random_hint;;
  esac
}
