#!/bin/bash


brew_install() {
  ls /tmp -alt
  echo "bash env: ${BASH_ENV:-}"
  # installs brew packages
  for package in "$@"
  do
    brew install "$package"
  done
}
