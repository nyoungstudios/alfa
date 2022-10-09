#!/bin/bash

set -eu

curl_or_wget() {
  # downloads file from url with curl or wget
  # Usage: curl_or_wget [-s] url [output file]
  # -s is for silent mode
  # url is the url to download
  # output file is where to save the url contents to. Will output to stdout if not provided.

  # flags
  silent=0

  # sets input arguments
  newArgs=()

  for arg in "$@"
  do
    if [[ "$arg" == "-s" ]];
    then
      silent=1
    else
      newArgs+=("$arg")
    fi
  done

  set -- "${newArgs[@]}"

  # sets positional arguments
  url="${1:-}"
  output="${2:-}"

  if [[ -z "$url" ]];
  then
    echo "Must provide url"
    exit 1
  fi

  commandToRun=""

  if command -v "curl" > /dev/null 2>&1; then
    # if curl is installed
    commandToRun="curl -L"
    if [[ "$silent" == 1 ]];
    then
      commandToRun="$commandToRun -fsS"
    fi

    if ! [[ -z "$output" ]];
    then
      commandToRun="$commandToRun -o '$output'"
    fi
  elif command -v "wget" > /dev/null 2>&1; then
    # if wget is installed
    commandToRun="wget"
    if [[ "$silent" == 1 ]];
    then
      commandToRun="$commandToRun -q"
    fi

    if [[ -z "$output" ]];
    then
      commandToRun="$commandToRun -O-"
    else
      commandToRun="$commandToRun -O '$output'"
    fi
  else
    echo "Must have curl or wget installed"
    exit 1
  fi

  commandToRun="$commandToRun '$url'"

  eval $commandToRun

}
