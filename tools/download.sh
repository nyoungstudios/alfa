#!/bin/sh

set -eu

curl_or_wget() {
  # downloads file from url with curl or wget
  # Usage: curl_or_wget [-s] url [output file]
  # -s is for silent mode
  # url is the url to download
  # output file is where to save the url contents to. Will output to stdout if not provided.

  silent='0'

  if [ "${1:-}" = '-s' ]; then
    silent='1'
    shift
  fi

  url="${1:-}"
  output="${2:-}"

  if [ -z "$url" ]; then
    echo 'Must provide url'
    exit 1
  fi

  if command -v curl >/dev/null 2>&1; then
    # if curl is installed
    if [ "$silent" = '1' ]; then
      if [ -n "$output" ]; then
        curl -fsSL -o "$output" "$url"
      else
        curl -fsSL "$url"
      fi
    elif [ -n "$output" ]; then
      curl -L -o "$output" "$url"
    else
      curl -L "$url"
    fi
  elif command -v wget >/dev/null 2>&1; then
    # if wget is installed
    if [ "$silent" = '1' ]; then
      if [ -n "$output" ]; then
        wget -q -O "$output" "$url"
      else
        wget -q -O - "$url"
      fi
    elif [ -n "$output" ]; then
      wget -O "$output" "$url"
    else
      wget -O - "$url"
    fi
  else
    echo 'Must have curl or wget installed'
    exit 1
  fi
}
