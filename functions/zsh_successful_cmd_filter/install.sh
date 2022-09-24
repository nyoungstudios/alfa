#!/bin/bash

install_zsh_successful_cmd_filter() {
  # appends zshaddhistory and precmd hooks
  echo "" >> ~/.zshrc
  cat templates/zshrc_successful_cmd_hist.zsh >> ~/.zshrc
}
