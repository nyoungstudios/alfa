#!/bin/bash

command_exists() {
  # tests if command exists
  command -v "$@" >/dev/null 2>&1
}

install_brew() {
  # Installs homebrew
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

brew_install() {
  # installs brew packages
  for package in "$@"
  do
    brew install "$package"
  done
}

brew_install_cask() {
  # installs brew cask packages
  for package in "$@"
  do
    brew install "$package" --cask
  done
}

install_ohmyzsh() {
  # install ohmyzsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

prettify_terminal() {
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

install_vimrc() {
  # install ultimate vimrc
  git clone --depth=1 https://github.com/nyoungstudios/vimrc.git ~/.vim_runtime
  sh ~/.vim_runtime/install_awesome_vimrc.sh
  git config --global core.editor "vim"
}

create_git_config() {
  # sets up git config name and email
  git config --global user.name "$1"
  git config --global user.email "$2"
  ssh-keygen -q -t rsa -C "$2" -N '' <<< ""$'\n'"y" 2>&1 >/dev/null
}

git_clone_repo() {
  # clones any number of git repositories to a local folder while retaining the
  # repo's project name.
  # the first argument is the local directory and all arguments following
  # are the urls
  dir="$1"
  shift
  mkdir -p "$dir"
  for repo in "$@"
  do
    git -C "$dir" clone "$repo"
  done
}

install_anaconda3() {
  # installs anaconda3
  echo "Installing Anaconda3..."
  curl https://repo.anaconda.com/archive/Anaconda3-2021.11-MacOSX-x86_64.sh -o ~/anaconda3.sh
  chmod +x ~/anaconda3.sh
  bash ~/anaconda3.sh -b -p ~/anaconda3
  rm ~/anaconda3.sh

  echo "Initializing Anaconda3..."
  export PATH=~/anaconda3/bin:$PATH
  conda init zsh
}

copy_pip_config() {
  # copies pip config
  mkdir -p ~/.pip && cp "$1" ~/.pip/pip.conf
}

install_nvm() {
  # installs nvm
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
}

install_node() {
  # installs specfied version of node; otherwise, will install latest version
  . $NVM_DIR/nvm.sh
  if [ -z "$1"];
  then
    nvm install node
  else
    nvm install "$1"
  fi
}

install_node_lts() {
  # installs the latest node lts version
  . $NVM_DIR/nvm.sh
  nvm install --lts
}

install_atom_packages() {
  # installs atom packages
  for package in "$@"
  do
    apm install "$package"
  done
}

install_sdkman() {
  # installs sdkman
  curl -s "https://get.sdkman.io?rcupdate=false" | bash
  cat templates/sdkman.zsh >> ~/.zshrc
}

run_zsh() {
  # runs zsh so you can see all the new changes
  exec zsh -l
}
