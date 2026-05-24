#!/bin/bash

install_atom_packages() {
  # installs atom packages
  for package in "$@"
  do
    if [ -d "$package" ]; then
      apm link "$package"
    else
      apm install "$package"
    fi
  done
}
