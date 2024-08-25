#!/bin/bash

set -eu

ALFA_USER="${SUDO_USER:-${USER:-}}"
echo $ALFA_USER

echo before
whoami
sudo echo hi
echo after

