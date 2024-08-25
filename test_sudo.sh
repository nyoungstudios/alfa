#!/bin/bash

set -eu


echo before
whoami
echo hi | sudo -S
sudo -v
echo after

sudo echo hi
