#!/bin/bash

install_binary_macos() {
  local url="$1"
  local tmp_dir
  tmp_dir=$(mktemp -d)
  local binary_name
  binary_name=$(basename "$url")

  curl_or_wget "$url" "$tmp_dir/$binary_name"

  local install_dir="${ALFA_INSTALL_BIN_DIR:-/usr/local/bin}"
  local install_permissions="${ALFA_INSTALL_PERMISSIONS:-755}"

  sudo cp "$tmp_dir/$binary_name" "$install_dir"
  sudo chmod "$install_permissions" "$install_dir/$binary_name"

  rm -rf "$tmp_dir"
}

install_binary_linux() {
  local url="$1"
  local tmp_dir
  tmp_dir=$(mktemp -d)
  local binary_name
  binary_name=$(basename "$url")

  curl_or_wget "$url" "$tmp_dir/$binary_name"

  local install_dir="${ALFA_INSTALL_BIN_DIR:-/usr/local/bin}"
  local install_permissions="${ALFA_INSTALL_PERMISSIONS:-755}"

  sudo cp "$tmp_dir/$binary_name" "$install_dir"
  sudo chmod "$install_permissions" "$install_dir/$binary_name"

  rm -rf "$tmp_dir"
}
