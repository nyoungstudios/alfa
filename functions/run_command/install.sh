#!/bin/bash

install_run_command() {
  cmd=""
  for arg in "$@"
  do
    quotedArg="'$(echo "$arg" | sed "s/'/'\"'\"'/g")'"
    if [ -n "$cmd" ];
    then
      cmd="${cmd} "
    fi
    cmd="${cmd}${quotedArg}"
  done
  set -x
  eval "$cmd"
}
