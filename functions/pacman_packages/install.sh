#!/bin/bash

install_pacman_packages() {
  # installs pacman packages
  pacman -Sy --noconfirm "$@"
}
