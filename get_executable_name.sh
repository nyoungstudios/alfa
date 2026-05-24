#!/bin/sh
# gets the alfa executable name based on the operating system and architecture

set -eu

unameSystem="$(uname -s)"
unameMachine="$(uname -m)"

if [ "$unameSystem" = "Linux" ] && { [ "$unameMachine" = "x86_64" ] || [ "$unameMachine" = "aarch64" ]; }; then
  alfaCommand="alfa_linux_$unameMachine"
elif [ "$unameSystem" = "Darwin" ] && { [ "$unameMachine" = "x86_64" ] || [ "$unameMachine" = "arm64" ]; }; then
  alfaCommand="alfa_macos_$unameMachine"
else
  echo "alfa cannot run on ${unameSystem} ${unameMachine}. It can only run on Linux and macOS."
  exit 1
fi

# prints executable name
echo "$alfaCommand"
