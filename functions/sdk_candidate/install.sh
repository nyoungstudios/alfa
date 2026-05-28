#!/bin/sh

install_sdk_candidate() {
  # installs an sdk candidate
  set +eu
  . "$HOME/.sdkman/bin/sdkman-init.sh"
  sdk install "$@"
  set -eu
}
