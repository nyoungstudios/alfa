#!/bin/sh

install_git_clone_and_run_script() {
  # creates parent directory and cd's into it
  dir="$1"
  case "$dir" in
    '~'*)
      dir="$HOME${dir#\~}"
      ;;
  esac
  shift
  mkdir -p "$dir"
  cd "$dir"

  # clones repo and cd's into it
  repo="$1"
  shift
  git -C "$dir" clone "$repo"
  repoDir="$(basename "$repo" .git)"

  (
    cd "$repoDir"

    # executes commands within the repo's directory
    for cmd in "$@"
    do
      sh -c "$cmd"
    done
  )

  # removes repo's directory if the env var is set to 1 or true
  if [ "${ALFA_REMOVE_REPO:-}" = "1" ] || [ "$(echo "${ALFA_REMOVE_REPO:-}" | tr '[:upper:]' '[:lower:]')" == "true" ];
  then
    rm -rf "$repoDir"
  fi
}
