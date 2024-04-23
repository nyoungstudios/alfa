#!/bin/bash

install_anaconda3_common() {
  chmod +x ~/anaconda3.sh
  # eval command to support evaluating environment variable strings passed from the config
  installLocation="$(eval echo ${ANACONDA_PREFIX:-$HOME/anaconda3})"
  bash ~/anaconda3.sh -b -p "$installLocation"
  rm ~/anaconda3.sh

  echo "Initializing Anaconda3..."
  export PATH="$installLocation/bin:$PATH"
  if [[ -f "$HOME/.bashrc" ]]; then
      conda init bash
  fi

  if [[ -f "$HOME/.zshrc" ]]; then
      conda init zsh
  fi
}

install_anaconda3_macos() {
  # installs anaconda3
  echo "Installing Anaconda3..."
  curl_or_wget "${1:-https://repo.anaconda.com/archive/Anaconda3-2024.02-1-MacOSX-${ALFA_ARCH}.sh}" ~/anaconda3.sh
  install_anaconda3_common
}

install_anaconda3_linux() {
  # installs anaconda3
  echo "Installing Anaconda3..."
  curl_or_wget "${1:-https://repo.anaconda.com/archive/Anaconda3-2024.02-1-Linux-${ALFA_ARCH}.sh}" ~/anaconda3.sh
  install_anaconda3_common
}
