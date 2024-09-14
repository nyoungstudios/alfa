#!/bin/bash

set -x

install_awscli_macos() {
  TMP_DIR="$(mktemp -d)"
  curl_or_wget -s "https://awscli.amazonaws.com/AWSCLIV2.pkg" "$TMP_DIR/awscliv2.zip"
  installer -pkg "$TMP_DIR/awscliv2.zip" -target /
  rm -rf "$TMP_DIR"
}

install_awscli_linux() {
  TMP_DIR="$(mktemp -d)"
  curl_or_wget -s "https://awscli.amazonaws.com/awscli-exe-linux-$ALFA_ARCH.zip" "$TMP_DIR/awscliv2.zip"
  unzip -q "$TMP_DIR/awscliv2.zip" -d "$TMP_DIR"
  "$TMP_DIR/aws/install"
  rm -rf "$TMP_DIR"
}
