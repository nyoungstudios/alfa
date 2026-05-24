#!/bin/sh

set -eu

version_is_greater_than() {
  left="${1#v}"
  right="${2#v}"

  old_ifs=$IFS
  IFS=.
  set -- $left
  IFS=$old_ifs
  left_major=${1:-0}
  left_minor=${2:-0}
  left_patch=${3:-0}

  IFS=.
  set -- $right
  IFS=$old_ifs
  right_major=${1:-0}
  right_minor=${2:-0}
  right_patch=${3:-0}

  if [ "$left_major" -gt "$right_major" ]; then
    return 0
  fi
  if [ "$left_major" -lt "$right_major" ]; then
    return 1
  fi
  if [ "$left_minor" -gt "$right_minor" ]; then
    return 0
  fi
  if [ "$left_minor" -lt "$right_minor" ]; then
    return 1
  fi

  [ "$left_patch" -gt "$right_patch" ]
}

cleanup_sudo_loop() {
  if [ -n "${loopPid:-}" ]; then
    command kill "$loopPid" 2>/dev/null || true
    wait "$loopPid" 2>/dev/null || true
    loopPid=''
  fi
}

start_sudo_loop() {
  (
    sleepPid=''

    cleanup_inner_loop() {
      trap - INT TERM EXIT
      if [ -n "$sleepPid" ]; then
        command kill "$sleepPid" 2>/dev/null || true
        wait "$sleepPid" 2>/dev/null || true
        sleepPid=''
      fi
      exit 0
    }

    trap 'cleanup_inner_loop' INT TERM EXIT

    while :
    do
      sudo -v || exit 1
      sleep 59 &
      sleepPid=$!
      wait "$sleepPid"
      sleepPid=''
    done
  ) &

  loopPid=$!
}

# checks if install.sh is run from the correct directory
if [ ! -f Makefile ]; then
  echo "install.sh must be run from the root directory of the alfa repo"
  exit 1
fi

hasRunZsh='0'
runShellFlag='0'
shellToRun=''
exitAfterAlfa='0'

# parse arguments that affect install.sh behavior
for argument in "$@"
do
  if [ "$argument" = '-h' ] || [ "$argument" = '--help' ]; then
    exitAfterAlfa='1'
  elif [ "$argument" = '-n' ] || [ "$argument" = '--dry-run' ]; then
    exitAfterAlfa='1'
  elif [ "$argument" = '--run-zsh' ]; then
    # TODO: remove run-zsh flag with next major release (v2.X.X), keeping for backwards compatibility
    hasRunZsh='1'
    shellToRun='zsh'
  elif [ "$argument" = '-r' ] || [ "$argument" = '--run-shell' ]; then
    runShellFlag='1'
  elif [ "$runShellFlag" = '1' ]; then
    shellToRun="$argument"
    runShellFlag='0'
  fi
done

alfaCommand=''

# gets the alfa executable name based on the operating system and architecture
unameSystem="$(uname -s)"
unameMachine="$(uname -m)"

if [ "$unameSystem" = 'Linux' ] && { [ "$unameMachine" = 'x86_64' ] || [ "$unameMachine" = 'aarch64' ]; }; then
  alfaCommand="alfa_linux_$unameMachine"
elif [ "$unameSystem" = 'Darwin' ] && { [ "$unameMachine" = 'x86_64' ] || [ "$unameMachine" = 'arm64' ]; }; then
  alfaCommand="alfa_macos_$unameMachine"
else
  echo "alfa cannot run on ${unameSystem} ${unameMachine}. It can only run on Linux and macOS."
  exit 1
fi

# downloads executable if it does not exist already
if [ ! -f "$alfaCommand" ]; then
  version=''
  if [ -f version.txt ]; then
    version="$(grep -Ev '^((//|#)|[[:space:]]*$)' version.txt | head -n 1 || true)"
  fi

  if [ -f functions.sh ] && { [ "$version" = 'latest' ] || version_is_greater_than "$version" 'v1.1.0'; }; then
    echo 'Get the latest commit from origin/main or specify alfa version <= v1.1.0'
    exit 1
  fi

  if [ -z "$version" ] || ! printf '%s\n' "$version" | grep -Eq '^v[0-9]+\.[0-9]+\.[0-9]+$'; then
    if ! command -v git >/dev/null 2>&1; then
      echo 'Must have git installed to download the latest version'
      exit 1
    fi
    version="$(git tag -l --sort=-v:refname | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' | head -n 1 || true)"
  fi

  if [ -z "$version" ]; then
    echo 'Unable to determine which alfa version to download'
    exit 1
  fi

  url="https://github.com/nyoungstudios/alfa/releases/download/${version}/${alfaCommand}"

  . ./tools/download.sh
  curl_or_wget -s "$url" "$alfaCommand"

  chmod +x "$alfaCommand"
fi

if [ "$exitAfterAlfa" = '1' ]; then
  exec "./$alfaCommand" "$@"
fi

export ALFA_ARCH="$unameMachine"
export ALFA_USER="${SUDO_USER:-${USER:-}}"

# runs the alfa command depending upon if sudo exists
if ! command -v sudo >/dev/null 2>&1; then
  # sudo command doesn't exist
  "./$alfaCommand" "$@"
else
  # sudo command exists
  if [ "$(id -u)" -eq 0 ] && [ "${SUDO_GID:-1}" -eq 0 ]; then
    echo 'Some things may not install properly if this is called as root. This script will call sudo when needed.'
  fi

  sudo -v
  start_sudo_loop
  trap 'cleanup_sudo_loop' INT TERM EXIT

  if sudo --preserve-env=ALFA_USER,ALFA_ARCH "./$alfaCommand" "$@"; then
    alfaStatus=0
  else
    alfaStatus=$?
  fi

  cleanup_sudo_loop
  trap - INT TERM EXIT

  if [ "$alfaStatus" -ne 0 ]; then
    exit "$alfaStatus"
  fi
fi

# runs the shell
if [ -n "$shellToRun" ]; then
  echo
  echo '--------------------------------------------'
  # TODO: remove hasRunZsh conditional on next major release (v2.X.X)
  if [ "$hasRunZsh" = '1' ]; then
    echo "Warning: the '--run-zsh' flag is deprecated and will be removed in v2. Please use '--run-shell zsh' instead."
    echo
  fi
  echo 'Run "chsh -s $(which '"$shellToRun"')" to change your default shell to '"$shellToRun"'. Logout and log back in to see the changes.'
  echo "Running a new '$shellToRun' shell in login mode..."
  # runs the shell in login mode so you can see all the new changes
  exec "$shellToRun" -l
fi
