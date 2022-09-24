#!/bin/bash

install_node_lts() {
  # installs the latest node lts version
  NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
  . $NVM_DIR/nvm.sh
  nvm install --lts
}
