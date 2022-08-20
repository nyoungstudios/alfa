#!/bin/bash

set -eu

# if [ "$EUID" -eq 0 ]; then
#   echo "Please do not run as root, this script will automatically call sudo when needed."
#   exit
# fi

# checks if install.sh is run from the correct directory
if [[ ! -f "functions.sh" ]]; then
  echo "install.sh must be run from the root directory of the alfa repo"
  exit 1
fi

alfaCommand=""

# sets the alfa command variable based on the operating system
unameResults="$(uname -s)"
if [[ "Linux" == *"$unameResults"* ]]; then
  alfaCommand="alfa_linux"
elif [[ "Darwin" == *"$unameResults"* ]]; then
  alfaCommand="alfa_macos"
else
  echo "alfa cannot run on ${unameResults}. It can only run on Linux and macOS."
  exit 1
fi

# runs the alfa command depending upon if sudo exists
if ! command -v "sudo" > /dev/null 2>&1; then
  # command doesn't exist
  ./$alfaCommand "$@"
else
  # command exists
  sudo ./$alfaCommand -u "$(whoami)" "$@"
fi

hasHelp="0"
hasRunShell="0"

# checks if the help and run-zsh arguments were passed
for argument in "$@"
do
  if [[ "$argument" == "-h" || "$argument" == "--help" ]]; then
    hasHelp="1"
  elif [[ "$argument" == "-r" || "$argument" == "--run-zsh" ]]; then
    hasRunShell="1"
  fi
done

# runs zsh
if [[ "$hasHelp" == "0" && "$hasRunShell" == "1" ]]; then
  /bin/bash -euc "source functions.sh; run_zsh"
fi
