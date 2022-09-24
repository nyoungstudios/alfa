#!/bin/bash

brew_install_cask() {
  # installs brew cask packages
  for package in "$@"
  do
    brew install "$package" --cask
  done
}
