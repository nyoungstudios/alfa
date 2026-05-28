#!/bin/sh

install_pacman_packages() {
  # installs pacman packages
  pacman -Sy --noconfirm "$@"
}
