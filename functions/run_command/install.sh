#!/bin/bash

install_run_command() {
  cmd=""
  for arg in "$@"
  do
    quotedArg="'$(echo "$arg" | sed "s/'/'\"'\"'/g")'"
    if [[ ! -z "$cmd" ]];
    then
      cmd+=" "
    fi
    cmd+="$quotedArg"
  done
  set -x
  eval "$cmd"
  set +x
}
