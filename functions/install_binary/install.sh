#!/bin/bash

install_binary() {
  url="$1"

  # checks if it is a remote or local file
  if [[ "$url" =~ ^https?:// ]]; then
    isHttp=true
  else
    isHttp=false
  fi

  if [[ -z "${ALFA_INSTALL_BINARY_NAME:-}" ]]; then
    binaryName=$(basename "$url")
  else
    binaryName="$ALFA_INSTALL_BINARY_NAME"
  fi

  # downloads if it is a remote file
  if [[ "$isHttp" == "true" ]]; then
    tmpDir=$(mktemp -d)
    curl_or_wget "$url" "$tmpDir/$binaryName"
    binaryLocalPath="$tmpDir/$binaryName"
  else
    binaryLocalPath="$url"
  fi

  installDir="${ALFA_INSTALL_BINARY_BIN_DIR:-/usr/local/bin}"

  # BSD and GNU versions of install are different but work the same for these options
  install -o root -g root -m "${ALFA_INSTALL_BINARY_PERMISSIONS:-755}" "$binaryLocalPath" "$installDir/$binaryName"

  # cleans up temporary directory
  if [[ "$isHttp" == "true" ]]; then
    rm -rf "$tmpDir"
  fi
}
