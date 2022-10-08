#!/bin/bash

install_brew() {
  # Installs homebrew
  NONINTERACTIVE=1
  /bin/bash -c "$(curl_or_wget -s https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}
