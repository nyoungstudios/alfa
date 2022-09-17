#!/bin/bash

set -eu

# checks if the alfa executable exists
if [[ ! -f "alfa" ]]; then
  echo "alfa executable must exist."
  exit 1
fi

# renames the alfa executable based on the operating system and architecture
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

# renames the file
mv alfa $alfaCommand

echo "Renames executable to $alfaCommand"
