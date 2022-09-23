#!/bin/bash

install_sdkman() {
  # installs sdkman
  curl -s "https://get.sdkman.io?rcupdate=false" | bash
  if [[ -f "$HOME/.bashrc" ]]; then
    cat templates/sdkman.zsh >> ~/.bashrc
  fi

  if [[ -f "$HOME/.zshrc" ]]; then
    cat templates/sdkman.zsh >> ~/.zshrc
  fi
}
