#!/bin/sh

install_sdk_candidate() {
  # installs an sdk candidate
  bash -c '
    set +eu
    . "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk install "$@"
  ' _ "$@"
}
