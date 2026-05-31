#!/bin/sh

install_node_lts() {
  # installs the latest node lts version
  NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
  _=/bin/sh
  . "$NVM_DIR/nvm.sh"
  nvm install --lts
}
