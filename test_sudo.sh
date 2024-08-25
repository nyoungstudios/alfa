#!/bin/bash

set -eu


echo before
whoami
echo hi | sudo -S -v
sudo -v
echo after

sudo echo hi
