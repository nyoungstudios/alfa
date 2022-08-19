#!/bin/bash

set -eu

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

hasHelp="0"
hasRunShell="0"

for argument in "$@"
do
  if [[ "$argument" == "-h" || "$argument" == "--help" ]]; then
    hasHelp="1"
  elif [[ "$argument" == "-r" || "$argument" == "--run-zsh" ]]; then
    hasRunShell="1"
  fi
done

if [[ "$hasHelp" == "0" && "$hasRunShell" == "1" ]]; then
  /bin/bash -euc "source functions.sh; run_zsh"
fi
