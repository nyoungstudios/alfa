#!/bin/bash

install_deb_package() {
  # installs a deb package
  filepath="/tmp/file_to_install.deb"
  wget -O "$filepath" "$@"
  apt-get install -y "$filepath"
  rm -f "$filepath"
}
