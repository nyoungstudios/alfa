#!/bin/bash

prettify_terminal_macos() {
  # clone Powerlevel10k repo and copy .p10k.zsh config file
  echo "Cloning Powerlevel10k theme"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  cp templates/.p10k.zsh ~/.p10k.zsh

  # edit the .zshrc
  echo "Changing .zshrc file to Powerlevel10k theme"
  cat ~/.zshrc | pbcopy && cat templates/p10k_init.zsh templates/zshrc_disable_flag.zsh > ~/.zshrc && pbpaste >> ~/.zshrc
  echo "" >> ~/.zshrc
  cat templates/p10k_config.zsh >> ~/.zshrc

  # replaces the default theme with the p10k theme
  sed -i '.old' 's+ZSH_THEME="robbyrussell"+ZSH_THEME="powerlevel10k/powerlevel10k"+g' ~/.zshrc
  rm ~/.zshrc.old
}

prettify_terminal_linux() {
  # clone Powerlevel10k repo and copy .p10k.zsh config file
  echo "Cloning Powerlevel10k theme"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  cp templates/.p10k.zsh ~/.p10k.zsh

  # edit the .zshrc
  echo "Changing .zshrc file to Powerlevel10k theme"
  sed -i '1 e cat templates/p10k_init.zsh && cat templates/zshrc_disable_flag.zsh' ~/.zshrc
  echo "" >> ~/.zshrc
  cat templates/p10k_config.zsh >> ~/.zshrc

  # replaces the default theme with the p10k theme
  sed -i 's+ZSH_THEME="robbyrussell"+ZSH_THEME="powerlevel10k/powerlevel10k"+g' ~/.zshrc
}
