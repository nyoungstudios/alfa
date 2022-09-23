#!/bin/bash

install_node() {
  # installs specfied version of node; otherwise, will install latest version
  NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
  . $NVM_DIR/nvm.sh
  if [ -z "$1"];
  then
    nvm install node
  else
    nvm install "$1"
  fi
}
