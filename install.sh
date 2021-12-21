#!/bin/bash

for arg in "$@"
do
  /bin/bash -exuc "source functions.sh; $arg"
done
