#!/bin/bash

install_vscode_extensions() {
  # installs vs code extensions (needs to be installed in non sudo mode)
  for extension in "$@"
  do
    code --install-extension "$extension"
  done
}
