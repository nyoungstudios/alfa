#!/bin/bash

install_ohmyzsh_plugins() {
  # installs plugins for ohmyzsh
  for repo in "$@"
  do
    git -C "${ZSH_CUSTOM:-${ZSH:-$HOME/.oh-my-zsh}/custom}/plugins" clone --depth=1 "$repo"
  done
}
