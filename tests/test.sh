#!/bin/sh

# tests all functions
/bin/sh -exuc "source functions.sh; install_brew"
/bin/sh -exuc "source functions.sh; brew_install jq"
/bin/sh -exuc "source functions.sh; brew_install_cask atom"
/bin/sh -exuc "source functions.sh; install_ohmyzsh"
/bin/sh -exuc "source functions.sh; prettify_terminal"
/bin/sh -exuc "source functions.sh; install_vimrc"
/bin/sh -exuc "source functions.sh; install_anaconda3"
/bin/sh -exuc "source functions.sh; run_zsh"
