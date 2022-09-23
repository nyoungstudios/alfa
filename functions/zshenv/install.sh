#!/bin/bash

append_to_zshenv() {
  # appends a line to zshenv file
  for line in "$@"
  do
    echo "$line" >> ~/.zshenv
  done
}
