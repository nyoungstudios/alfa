#!/bin/bash

set -eu

# checks if the alfa executable exists
if [[ ! -f "alfa" ]]; then
  echo "alfa executable must exist."
  exit 1
fi

# renames the alfa executable based on the operating system
unameResults="$(uname -s)"
if [[ "Linux" == *"$unameResults"* ]]; then
  alfaCommand="alfa_linux"
elif [[ "Darwin" == *"$unameResults"* ]]; then
  alfaCommand="alfa_macos"
else
  echo "alfa cannot run on ${unameResults}. It can only run on Linux and macOS."
  exit 1
fi

# renames the file
mv alfa $alfaCommand

echo "Renames executable to $alfaCommand"
