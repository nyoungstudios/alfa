#!/bin/bash

install_run_command() {
  cmd="$1"
  shift
  eval "$cmd" $@
}
