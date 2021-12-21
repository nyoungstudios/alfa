#!/bin/bash

# tests all functions
/bin/bash -exuc "source functions.sh; install_brew"
/bin/bash -exuc "source functions.sh; brew_install jq"
/bin/bash -exuc "source functions.sh; brew_install_cask atom"
/bin/bash -exuc "source functions.sh; install_ohmyzsh"
/bin/bash -exuc "source functions.sh; prettify_terminal"
/bin/bash -exuc "source functions.sh; install_vimrc"
/bin/bash -exuc "source functions.sh; install_anaconda3"
/bin/bash -exuc "source functions.sh; run_zsh"
