#!/bin/bash

install_atom_packages() {
  # installs atom packages
  for package in "$@"
  do
    apm install "$package"
  done
}
