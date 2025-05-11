#!/bin/bash

ls /tmp -alt
echo "bash env: $BASH_ENV"


brew_install() {
  # installs brew packages
  for package in "$@"
  do
    brew install "$package"
  done
}
