#!/bin/sh
# gets the alfa executable name based on the operating system and architecture

set -eu

unameSystem="$(uname -s)"
unameMachine="$(uname -m)"

if [ "$unameSystem" = "Linux" ]; then
  alfaCommand="alfa_linux_$unameMachine"
  case "$unameMachine" in
    x86_64|aarch64|riscv64)
      alfaCommand="alfa_linux_$unameMachine"
      ;;
    armv7l)
      alfaCommand="alfa_linux_arm7"
      ;;
    *)
      echo "alfa cannot run on Linux for architecture: ${unameMachine}"
      exit 1
      ;;
  esac
elif [ "$unameSystem" = "Darwin" ]; then
  case "$unameMachine" in
    x86_64|arm64)
      alfaCommand="alfa_macos_$unameMachine"
      ;;
    *)
      echo "alfa cannot run on macOS for architecture: $unameMachine"
      exit 1
      ;;
  esac
else
  echo "alfa cannot run on ${unameSystem} ${unameMachine}. It can only run on Linux and macOS."
  exit 1
fi

# prints executable name
echo "$alfaCommand"
