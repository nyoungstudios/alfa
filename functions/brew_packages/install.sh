#!/bin/bash

brew_install() {
  # installs brew packages
  for package in "$@"
  do
    brew install "$package"
  done
}
