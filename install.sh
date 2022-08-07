#!/bin/bash

# if [ "$EUID" -eq 0 ]; then
#   echo "Please do not run as root, this script will automatically call sudo when needed."
#   exit
# fi


if ! command -v "sudo" > /dev/null 2>&1; then
  # command doesn't exist
  ./alfa_linux "$@"
else
  # command exists
  sudo ./alfa_linux -u "$(whoami)" "$@"
fi
