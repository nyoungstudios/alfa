#!/bin/bash

set -eu

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
  # sudo command doesn't exist
  ./$alfaCommand "$@"
else
  # sudo command exists

  if [[ "$EUID" -eq 0 && "$SUDO_GID" -eq 0 ]]; then
    echo "Some things may not install properly if this is called as root. This script will call sudo when needed."
  fi

  sudo -v
  # keep refreshing sudo in the background every 59 seconds
  while :; do sudo -v; sleep 59; done &
  loopPid="$!"

  export ALFA_USER="${SUDO_USER:-${USER:-}}"; sudo --preserve-env=ALFA_USER ./$alfaCommand "$@"

  trap 'trap - SIGTERM && kill $(pgrep -P $loopPid) $loopPid' SIGINT SIGTERM EXIT

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
  echo 'Run "chsh -s $(which zsh)" to change your default shell to zsh. Logout and log back in to see the changes.'
  # runs zsh so you can see all the new changes
  exec zsh -l
fi
