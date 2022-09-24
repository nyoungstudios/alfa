#!/bin/bash

install_vimrc() {
  # install ultimate vimrc
  git clone --depth=1 https://github.com/nyoungstudios/vimrc.git ~/.vim_runtime
  sh ~/.vim_runtime/install_awesome_vimrc.sh
  git config --global core.editor "vim"
}
