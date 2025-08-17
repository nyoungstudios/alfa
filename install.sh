#!/bin/bash

set -euo pipefail

# checks if install.sh is run from the correct directory
if [[ ! -f "Makefile" ]]; then
  echo "install.sh must be run from the root directory of the alfa repo"
  exit 1
fi

alfaCommand=""

# gets the alfa executable name based on the operating system and architecture
unameSystem="$(uname -s)"
unameMachine="$(uname -m)"

if [[ "Linux" == "$unameSystem" && ( "x86_64" == "$unameMachine" || "aarch64" == "$unameMachine" ) ]]; then
  alfaCommand="alfa_linux_$unameMachine"
elif [[ "Darwin" == "$unameSystem" && ( "x86_64" == "$unameMachine" || "arm64" == "$unameMachine" ) ]]; then
  alfaCommand="alfa_macos_$unameMachine"
else
  echo "alfa cannot run on ${unameSystem} ${unameMachine}. It can only run on Linux and macOS."
  exit 1
fi

# downloads executable if it does not exist already
if [[ ! -f "$alfaCommand" ]]; then
  version=""
  if [[ -f "version.txt" ]]; then
    version=`cat version.txt | grep -Ev '^((//|#)|[[:space:]]*$)' | head -n 1`
  fi

  if [[ -f "functions.sh" && ( "$version" == "latest" || "$version" > "v1.1.0" ) ]]; then
    echo "Get the lastest commit from origin/main or specify alfa version <= v1.1.0"
    exit 1
  fi

  if [[ -z "$version" || -z "$(echo $version | grep -E '^v[0-9]+.[0-9]+.[0-9]+$')" ]]; then
    if ! command -v "git" > /dev/null 2>&1; then
      echo "Must have git installed to download the latest version"
      exit 1
    fi
    version=`git tag -l --sort=-v:refname | grep -E '^v[0-9]+.[0-9]+.[0-9]+$' | head -n 1`
  fi

  url="https://github.com/nyoungstudios/alfa/releases/download/${version}/${alfaCommand}"

  source tools/download.sh; curl_or_wget -s "$url" "$alfaCommand"

  chmod +x "$alfaCommand"

fi

export ALFA_ARCH="$unameMachine"
export ALFA_USER="${SUDO_USER:-${USER:-}}"

# runs the alfa command depending upon if sudo exists
if ! command -v "sudo" > /dev/null 2>&1; then
  # sudo command doesn't exist
  ./$alfaCommand "$@"
else
  # sudo command exists

  if [[ "$EUID" -eq 0 && "${SUDO_GID:-1}" -eq 0 ]]; then
    echo "Some things may not install properly if this is called as root. This script will call sudo when needed."
  fi

  sudo -v
  # keep refreshing sudo in the background every 59 seconds
  while :; do sudo -v; sleep 59; done &
  loopPid="$!"

  trap 'trap - SIGTERM && kill $(pgrep -P $loopPid) $loopPid' SIGINT SIGTERM EXIT

  sudo --preserve-env=ALFA_USER,ALFA_ARCH ./$alfaCommand "$@"

fi

runShellFlag="0"
shellToRun=""

# additional checks after running the alfa executable
# exits on help and dry-run
# runs shell if the run-shell argument is passed
for argument in "$@"
do
  if [[ "$argument" == "-h" || "$argument" == "--help" ]]; then
    exit
  elif [[ "$argument" == "-n" || "$argument" == "--dry-run" ]]; then
    exit
  elif [[ "$argument" == "--run-zsh" ]]; then
    # TODO: remove run-zsh flag with next major release (v2.X.X), keeping for backwards compatibility
    shellToRun="zsh"
  elif [[ "$argument" == "-r" || "$argument" == "--run-shell" ]]; then
    runShellFlag="1"
  elif [[ "$runShellFlag" == "1" ]]; then
    shellToRun="$argument"
    runShellFlag="0"
  fi
done

# runs the shell
if [[ -n "$shellToRun" ]]; then
  echo
  echo "--------------------------------------------"
  echo 'Run "chsh -s $(which '"$shellToRun"')" to change your default shell to '"$shellToRun"'. Logout and log back in to see the changes.'
  echo "Running a new '$shellToRun' shell in login mode..."
  # runs the shell in login mode so you can see all the new changes
  exec "$shellToRun" -l
fi
