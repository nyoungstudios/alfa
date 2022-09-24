#!/bin/bash

add_ohmyzsh_plugins_macos() {
  # adds ohmyzsh plugins to zshrc
  # replaces default plugin string
  sed -i '.old' 's+plugins=(git)+plugins=(\n  ### NEW PLUGINS HERE ###\n)+g' ~/.zshrc

  # builds plugin string
  plugins=""
  for name in "$@"
  do
    if  [[ -z "$plugins" ]]; then
      plugins="$name"
    else
      plugins="${plugins}\n  $name"

    fi
  done

  plugins="${plugins}\n  ### NEW PLUGINS HERE ###"

  # replaces flag with new plugin string
  sed -i '.old' "s+### NEW PLUGINS HERE ###+${plugins}+g" ~/.zshrc

  rm ~/.zshrc.old
}

add_ohmyzsh_plugins_linux() {
  # adds ohmyzsh plugins to zshrc
  # replaces default plugin string
  sed -i 's+plugins=(git)+plugins=(\n  ### NEW PLUGINS HERE ###\n)+g' ~/.zshrc

  # builds plugin string
  plugins=""
  for name in "$@"
  do
    if  [[ -z "$plugins" ]]; then
      plugins="$name"
    else
      plugins="${plugins}\n  $name"

    fi
  done

  plugins="${plugins}\n  ### NEW PLUGINS HERE ###"

  # replaces flag with new plugin string
  sed -i "s+### NEW PLUGINS HERE ###+${plugins}+g" ~/.zshrc
}
