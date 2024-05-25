#!/bin/bash

install_vimrc() {
  # install ultimate vimrc
  git clone --depth=1 "${1:-https://github.com/amix/vimrc.git}" ~/.vim_runtime
  sh ~/.vim_runtime/install_awesome_vimrc.sh

  # sets vim as default editor
  if [[ "${SET_AS_GIT_EDITOR:-}" == "1" || "$(echo "${SET_AS_GIT_EDITOR:-}" | tr '[:upper:]' '[:lower:]')" == "true" ]]; then
    git config --global core.editor "vim"
  fi
}
