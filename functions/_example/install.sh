#!/bin/bash

# A bash script to install something
# 1. Do not name the function to install something the same as an existing command. For example, the function to install brew
#    is not called "brew", but rather "install_brew".
# 2. To access the list of "options" in the config.toml file you pass to the installer, use the "$@" variable.
# 3. To access the user that called the installer, do not user the environment variable "$SUDO_USER", but rather use "$ALFA_USER".
# 4. To access the uname -m output (system architecture), you can use the environment variable "$ALFA_ARCH"
# 5. To download a file from the web, you can use the curl_or_wget function (tools/download.sh) which will use curl or wget depending upon
#    what the user has installed.

install_example() {
  # example function
  echo "$ALFA_USER called this function on a $ALFA_ARCH computer"
  for item in "$@"
  do
    echo "$item"
  done
}
