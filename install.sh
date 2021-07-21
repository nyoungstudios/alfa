#!/bin/sh

for arg in "$@"
do
  /bin/sh -exuc "source functions.sh; $arg"
done
