#!/bin/bash

install_anaconda3_macos() {
  # installs anaconda3
  echo "Installing Anaconda3..."
  curl "${1:-https://repo.anaconda.com/archive/Anaconda3-2022.05-MacOSX-${ALFA_ARCH}.sh}" -o ~/anaconda3.sh
  install_anaconda3_common
}

install_anaconda3_common() {
  chmod +x ~/anaconda3.sh
  bash ~/anaconda3.sh -b -p ~/anaconda3
  rm ~/anaconda3.sh

  echo "Initializing Anaconda3..."
  export PATH=~/anaconda3/bin:$PATH
  if [[ -f "$HOME/.bashrc" ]]; then
      conda init bash
  fi

  if [[ -f "$HOME/.zshrc" ]]; then
      conda init zsh
  fi
}

install_anaconda3_linux() {
  # installs anaconda3
  echo "Installing Anaconda3..."
  curl "${1:-https://repo.anaconda.com/archive/Anaconda3-2022.05-Linux-${ALFA_ARCH}.sh}" -o ~/anaconda3.sh
  install_anaconda3_common
}
