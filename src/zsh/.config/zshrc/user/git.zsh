#!/usr/bin/env zsh

function in_every_repo_root() {
  local depth=0
  local max_depth=0

  while [[ $# -gt 0 ]]; do
    case "${1}" in
      --depth) depth="${2}"; shift 2;;
      --max-depth) max_depth="${2}"; shift 2;;
      *) local command_to_execute="${1}"; shift;;
    esac
  done

  for directory in */ ; do
    builtin cd "${directory}" || return 1

    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
      echo "==> Executing ${command_to_execute} in $(pwd)"

      eval "${command_to_execute}"
    elif [[ "${depth}" -lt "${max_depth}" ]]; then
      in_every_repo_root "${command_to_execute}" --depth $(( depth + 1 )) --max-depth "${max_depth}"
    fi

    builtin cd .. || return 1
  done
}

function origin_head() {
  sed -n 's/.*\///p' .git/refs/remotes/origin/HEAD
}

function clean_branches() {
  # c.f. https://stackoverflow.com/questions/7726949/remove-tracking-branches-no-longer-on-remote/38404202#38404202
  local delete_flag='-d'

  while [[ $# -gt 0 ]]; do
    case "${1}" in
      --force) delete_flag='-D'; shift;;
      *) echo 'Error: invalid argument(s)'; return 1;;
    esac
  done

  git switch "$(origin_head)"
  git fetch --prune
  # the $1 is passed to awk and can't be in curly braces
  git branch -vv | awk '/: gone]/{print $1}' | xargs git branch "${delete_flag}"
  git switch -
}

function branches_by_last_update() {
  local non_head_branches
  non_head_branches=$(git branch | grep -v "$(origin_head)" | sed 's/\*/ /')

  local last_update
  for branch in $(echo -e "${non_head_branches}"); do
    last_update=$(git show --format='%ci' "${branch}" \
      | head -n 1 \
      | sed -r 's/:[0-9]{2} .*//')

    echo -e "${last_update} - ${branch}"
  done | sort --reverse
}

function cherry_pick_branch() {
  local branch=$1

  if [[ -z "${branch}" ]]; then
    echo 'Usage: cherry_pick_branch branch-name'
    return 1
  fi

  local start
  start=$(git merge-base "${branch}" "$(origin_head)")

  git cherry-pick "${start}..${branch}"
}
