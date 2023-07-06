#!/bin/bash

install_apk_packages() {
  # installs apk packages
  apk update
  apk add --no-interactive "$@"
}
