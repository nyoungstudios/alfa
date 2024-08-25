#!/bin/bash

set -eu


echo before
whoami
sudo -v
echo after

sudo echo hi
