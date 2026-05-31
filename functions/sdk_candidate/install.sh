#!/bin/bash

install_sdk_candidate() {
  # installs an sdk candidate
  set +eu
  source "$HOME/.sdkman/bin/sdkman-init.sh"
  sdk install "$@"
  set -eu
}
