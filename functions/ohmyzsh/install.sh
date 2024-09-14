#!/bin/bash

install_ohmyzsh() {
  # eval command to support evaluating environment variable strings passed from the config
  export ZSH="$(eval echo ${ZSH:-})"
  # install ohmyzsh
  sh -c "$(curl_or_wget -s https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}
