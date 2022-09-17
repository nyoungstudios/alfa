#!/bin/bash
# Contains the shell scripts to install all of your favorite tools
# Do not name the function to install something the same as the command. For example, the function to install brew is not called "brew", but
# rather "install_brew".
# To access the list of "options" in the config.toml file you pass to the installer, use the "$@" variable.
# To access the user that called the installer, do not user the environment variable "$SUDO_USER", but rather use "$ALFA_USER".
# To access the uname -m output (system architecture), you can use the environment variable "$ALFA_ARCH"

create_git_config() {
  # sets up git config name and email
  git config --global user.name "$1"
  git config --global user.email "$2"
  ssh-keygen -q -t rsa -C "$2" -N '' <<< ""$'\n'"y" 2>&1 >/dev/null
}

install_brew() {
  # Installs homebrew
  NONINTERACTIVE=1
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

apt_get_install() {
  # installs apt-get packages
  apt-get update
  apt-get install -y "$@"
}

install_deb_package() {
  # installs a deb package
  filepath="/tmp/file_to_install.deb"
  wget -O "$filepath" "$@"
  apt-get install -y "$filepath"
  rm -f "$filepath"
}

install_snap_package() {
  # installs a single snap package
  snap install "$@"
}

install_ohmyzsh() {
  # install ohmyzsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

install_zsh_successful_cmd_filter() {
  # appends zshaddhistory and precmd hooks
  echo "" >> ~/.zshrc
  cat templates/zshrc_successful_cmd_hist.zsh >> ~/.zshrc
}

install_ohmyzsh_plugins() {
  # installs plugins for ohmyzsh
  for repo in "$@"
  do
    git -C ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins clone --depth=1 "$repo"
  done
}

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

append_to_zshenv() {
  # appends a line to zshenv file
  for line in "$@"
  do
    echo "$line" >> ~/.zshenv
  done
}

install_vimrc() {
  # install ultimate vimrc
  git clone --depth=1 https://github.com/nyoungstudios/vimrc.git ~/.vim_runtime
  sh ~/.vim_runtime/install_awesome_vimrc.sh
  git config --global core.editor "vim"
}

install_jetbrains_toolbox() {
  # installs the jetbrains toolbox app (also should be run in non root mode)
  filepath="/tmp/jetbrains-toolbox.tar.gz"
  output_folder="/tmp/jetbrains-toolbox-tmp"
  version="jetbrains-toolbox-1.25.12627"
  mkdir -p "$output_folder"
  wget -O "$filepath" "https://download.jetbrains.com/toolbox/${version}.tar.gz"
  tar -xvf "$filepath" -C "$output_folder"
  pushd "${output_folder}/${version}"
  ./jetbrains-toolbox
  popd
  rm -rf "$filepath" "$output_folder"
}

install_docker() {
  # installs docker on linux
  apt-get update
  apt-get install -y --no-install-recommends ca-certificates curl gnupg lsb-release
  mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
  apt-get update
  apt-get install -y --no-install-recommends docker-ce docker-ce-cli containerd.io

  echo "Configuring docker to be run without calling sudo"
  groupadd -f docker
  gpasswd -a $ALFA_USER docker
  echo "Please restart your computer to use docker without calling sudo"
}

install_anaconda3_common() {
  chmod +x ~/anaconda3.sh
  bash ~/anaconda3.sh -b -p ~/anaconda3
  rm ~/anaconda3.sh

  echo "Initializing Anaconda3..."
  export PATH=~/anaconda3/bin:$PATH
  if [[ -f "$HOME/.bashrc" ]]; then
      conda init bash
  fi

  if [[ -f "$HOME/.zshrc" ]]; then
      conda init zsh
  fi
}

install_anaconda3_macos() {
  # installs anaconda3
  echo "Installing Anaconda3..."
  curl "${1:-https://repo.anaconda.com/archive/Anaconda3-2022.05-MacOSX-${ALFA_ARCH}.sh}" -o ~/anaconda3.sh
  install_anaconda3_common
}

install_anaconda3_linux() {
  # installs anaconda3
  echo "Installing Anaconda3..."
  curl "${1:-https://repo.anaconda.com/archive/Anaconda3-2022.05-Linux-${ALFA_ARCH}.sh}" -o ~/anaconda3.sh
  install_anaconda3_common
}

copy_pip_config() {
  # copies pip config
  mkdir -p ~/.pip && cp "$1" ~/.pip/pip.conf
}

install_nvm() {
  # installs nvm
  if [[ "$1" -eq 0 ]]; then
    # nvm installer will not change your profile or rc file.
    export PROFILE="/dev/null"
  fi
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
}

install_node_lts() {
  # installs the latest node lts version
  NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
  . $NVM_DIR/nvm.sh
  nvm install --lts
}

install_node() {
  # installs specfied version of node; otherwise, will install latest version
  NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
  . $NVM_DIR/nvm.sh
  if [ -z "$1"];
  then
    nvm install node
  else
    nvm install "$1"
  fi
}

install_sdkman() {
  # installs sdkman
  curl -s "https://get.sdkman.io?rcupdate=false" | bash
  if [[ -f "$HOME/.bashrc" ]]; then
    cat templates/sdkman.zsh >> ~/.bashrc
  fi

  if [[ -f "$HOME/.zshrc" ]]; then
    cat templates/sdkman.zsh >> ~/.zshrc
  fi
}

install_sdk_candidate() {
  # installs an sdk candidate
  set +eu
  source "$HOME/.sdkman/bin/sdkman-init.sh"
  sdk install "$@"
  set -eu
}

install_atom_packages() {
  # installs atom packages
  for package in "$@"
  do
    apm install "$package"
  done
}

install_vscode_extensions() {
  # installs vs code extensions (needs to be installed in non sudo mode)
  for extension in "$@"
  do
    code --install-extension "$extension"
  done
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
