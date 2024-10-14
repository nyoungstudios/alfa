#!/bin/bash

install_nvm() {
  # installs nvm
  if [[ "${1:-}" -eq 0 ]]; then
    # nvm installer will not change your profile or rc file.
    export PROFILE="/dev/null"
  fi
  curl_or_wget https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
}
