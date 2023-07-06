#!/bin/bash

install_yum_packages() {
  # installs yum packages
  yum install -y "$@"
}
