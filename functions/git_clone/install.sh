#!/bin/bash

git_clone_repo() {
  # clones any number of git repositories to a local folder while retaining the
  # repo's project name.
  # the first argument is the local directory and all arguments following
  # are the urls
  dir="${1/#\~/$HOME}"
  shift
  mkdir -p "$dir"
  for repo in "$@"
  do
    git -C "$dir" clone "$repo"
  done
}
