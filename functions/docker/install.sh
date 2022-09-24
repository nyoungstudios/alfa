#!/bin/bash

install_docker() {
  # installs docker on linux
  apt-get update
  apt-get install -y --no-install-recommends ca-certificates curl gnupg lsb-release
  mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
  apt-get update
  apt-get install -y --no-install-recommends docker-ce docker-ce-cli containerd.io

  echo "Configuring docker to be run without calling sudo"
  groupadd -f docker
  gpasswd -a $ALFA_USER docker
  echo "Please restart your computer to use docker without calling sudo"
}
