#!/usr/bin/env zsh

# usage: source_cached <cache name> <command> [<argument>...]
function source_cached() {
  local cache_file="${ZSH_CACHE_DIR}/${1}.zsh"
  shift

  local binary
  binary="$(command -v "${1}")"

  if [[ ! -s "${cache_file}" ]] || [[ "${binary}" -nt "${cache_file}" ]]; then
    if ! "${@}" > "${cache_file}.new"; then
      rm -f "${cache_file}.new"
      return 1
    fi

    mv "${cache_file}.new" "${cache_file}"
  fi

  # shellcheck disable=1090
  # the path is only known at runtime
  source "${cache_file}"
}
