#!/bin/bash

install_jetbrains_toolbox() {
  filepath="/tmp/jetbrains-toolbox.tar.gz"
  output_folder="/tmp/jetbrains-toolbox-tmp"
  archive_name="jetbrains-toolbox-3.4.3.81140"

  if [[ "$ALFA_ARCH" == "aarch64" ]]; then
    archive_name+="-arm64"
  fi

  mkdir -p "$output_folder"
  if ! curl_or_wget -s "https://download.jetbrains.com/toolbox/${archive_name}.tar.gz" "$filepath"; then
    echo "Failed to download JetBrains Toolbox archive: ${archive_name}.tar.gz" >&2
    rm -rf "$filepath" "$output_folder"
    return 1
  fi
  tar -xf "$filepath" -C "$output_folder"

  extracted_dir="${output_folder}/${archive_name}"
  if [[ ! -d "$extracted_dir" ]]; then
    extracted_dir="$(find "$output_folder" -mindepth 1 -maxdepth 1 -type d -name 'jetbrains-toolbox-*' | sort | head -n 1)"
  fi
  if [[ -z "$extracted_dir" ]]; then
    echo 'Unable to find extracted JetBrains Toolbox directory' >&2
    rm -rf "$filepath" "$output_folder"
    return 1
  fi

  install_dir="${HOME}/.local/share/JetBrains/Toolbox"
  mkdir -p "${HOME}/.local/share/JetBrains" "${HOME}/.local/bin"
  rm -rf "$install_dir"
  mv "$extracted_dir" "$install_dir"
  ln -sf "$install_dir/bin/jetbrains-toolbox" "${HOME}/.local/bin/jetbrains-toolbox"

  rm -rf "$filepath" "$output_folder"
}
