#!/bin/bash

create_git_config() {
  # sets up git config name and email
  git config --global user.name "$1"
  git config --global user.email "$2"
  ssh-keygen -q -t rsa -C "$2" -N '' <<< ""$'\n'"y" 2>&1 >/dev/null
}
