#!/bin/sh

set -eu

curl_or_wget() {
  # downloads file from url with curl or wget
  # Usage: curl_or_wget [-s] url [output file]
  # -s is for silent mode
  # url is the url to download
  # output file is where to save the url contents to. Will output to stdout if not provided.

  # flags
  silent='0'

  if [ "${1:-}" = '-s' ]; then
    silent='1'
    shift
  fi

  # sets positional arguments
  url="${1:-}"
  output="${2:-}"

  if [ -z "$url" ]; then
    echo 'Must provide url'
    exit 1
  fi

  if command -v curl >/dev/null 2>&1; then
    curl_opts='-L'
    if [ "$silent" = '1' ]; then
      curl_opts='-fsSL'
    fi

    if [ -n "$output" ]; then
      curl "$curl_opts" -o "$output" "$url"
    else
      curl "$curl_opts" "$url"
    fi
  elif command -v wget >/dev/null 2>&1; then
    wget_opts=''
    if [ "$silent" = '1' ]; then
      wget_opts='-q'
    fi

    if [ -n "$output" ]; then
      wget "$wget_opts" -O "$output" "$url"
    else
      wget "$wget_opts" -O - "$url"
    fi
  else
    echo 'Must have curl or wget installed'
    exit 1
  fi
}
