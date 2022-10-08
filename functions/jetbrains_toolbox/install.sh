#!/bin/bash

install_jetbrains_toolbox() {
  # installs the jetbrains toolbox app (also should be run in non root mode)
  filepath="/tmp/jetbrains-toolbox.tar.gz"
  output_folder="/tmp/jetbrains-toolbox-tmp"
  version="jetbrains-toolbox-1.25.12627"
  mkdir -p "$output_folder"
  curl_or_wget "https://download.jetbrains.com/toolbox/${version}.tar.gz" "$filepath"
  tar -xvf "$filepath" -C "$output_folder"
  pushd "${output_folder}/${version}"
  ./jetbrains-toolbox
  popd
  rm -rf "$filepath" "$output_folder"
}
