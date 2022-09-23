#!/bin/bash

apt_get_install() {
  # installs apt-get packages
  apt-get update
  apt-get install -y "$@"
}
