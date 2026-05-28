#!/usr/bin/env bash

# An example bash script install something using /usr/bin/env to reference a non-standard bash location
# See the _example folder for more docs

install_example() {
  echo "$ALFA_USER called this function on a $ALFA_ARCH computer using the $(ps -p $$ -o comm=) shell"
  for item in "$@"
  do
    echo "$item"
  done
}
