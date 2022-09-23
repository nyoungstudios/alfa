#!/bin/bash

# A bash script to install something
# Do not name the function to install something the same as an existing command. For example, the function to install brew
# is not called "brew", but rather "install_brew".
# To access the list of "options" in the config.toml file you pass to the installer, use the "$@" variable.
# To access the user that called the installer, do not user the environment variable "$SUDO_USER", but rather use "$ALFA_USER".
# To access the uname -m output (system architecture), you can use the environment variable "$ALFA_ARCH"

install_example() {
  # example function
  echo "$ALFA_USER called this function on a $ALFA_ARCH computer"
  for item in "$@"
  do
    echo "$item"
  done
}
