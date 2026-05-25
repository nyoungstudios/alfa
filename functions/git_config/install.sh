#!/bin/sh

create_git_config() {
  # sets up git config name and email
  git config --global user.name "$1"
  git config --global user.email "$2"
  # Send default file path (blank line) and confirm overwrite with "y".
  printf '\ny\n' | ssh-keygen -q -t rsa -C "$2" -N '' >/dev/null 2>&1
}
