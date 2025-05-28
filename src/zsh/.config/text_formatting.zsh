#!/usr/bin/env zsh

reset_code=0
bold_code=1

declare -A foreground_codes
foreground_codes=(
  black   30 bright-black   90
  red     31 bright-red     91
  green   32 bright-green   92
  yellow  33 bright-yellow  93
  blue    34 bright-blue    94
  magenta 35 bright-magenta 95
  cyan    36 bright-cyan    96
  white   37 bright-white   97
)

declare -A background_codes
background_codes=(
  black   40 bright-black   100
  red     41 bright-red     101
  green   42 bright-green   102
  yellow  43 bright-yellow  103
  blue    44 bright-blue    104
  magenta 45 bright-magenta 105
  cyan    46 bright-cyan    106
  white   47 bright-white   107
)

function set_text_format() {
  local codes=()

  while [[ $# -gt 0 ]]; do
    case $1 in
      --foreground) codes+=($foreground_codes[$2]); shift 2;;
      --background) codes+=($background_codes[$2]); shift 2;;
      --bold) codes+=($bold_code); shift;;
      --reset) codes=(); shift $#;;
      *) echo 'Error: invalid argument(s)'; exit 1;;
    esac
  done

  # we always reset at the start (so --reset is equivalent to no arguments)
  echo -n "\033[$reset_code;$(IFS=';' ; echo "${codes[*]}")m"
}
