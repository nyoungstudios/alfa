#!/bin/bash

install_deb_package() {
  # installs a deb package
  filepath="/tmp/file_to_install.deb"
  curl_or_wget "$1" "$filepath"
  apt-get install -y "$filepath"
  rm -f "$filepath"
}
