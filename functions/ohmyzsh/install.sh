#!/bin/bash

install_ohmyzsh() {
  # install ohmyzsh
  sh -c "$(curl_or_wget -s https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}
