# Functions

Contains the shell scripts to install all of your favorite tools
Do not name the function to install something the same as the command. For example, the function to install brew is not called "brew", but rather "install_brew".
To access the list of "options" in the config.toml file you pass to the installer, use the "$@" variable.
To access the user that called the installer, do not user the environment variable "$SUDO_USER", but rather use "$ALFA_USER".
To access the uname -m output (system architecture), you can use the environment variable "$ALFA_ARCH"
