# Alfa

📋 Alfa is tool to manage and share your dev environment configuration. Its modular approach allows you to easily group different configurations together. The goal was to create a way to install all of your favorite tools whether you are running on an x86 or ARM architecture computer for both on macOS and Linux operating systems.

✈️ As a flight sim enthusiast, *Alfa* is named after the first word in the NATO phonetic alphabet. While getting a new computer is always exciting, setting it up with all your tools and settings can be a little tedious. I hope this will help simplify your preflight steps so that you can focus on the flying part.

## Prerequisites

- Unix like operating system: macOS, Linux, or Windows WSL.
- `bash`
- `git`
- `wget` or `curl`

## Getting Started

### Cloning the repository

```shell
git clone https://github.com/nyoungstudios/alfa.git
cd alfa
```

This is the installer script (more on how to use it below):

```shell
./install.sh -h
```

### Configuration file

Config files are defined as `toml` files. This has the benefits of JSON, but friendlier for humans to read. Each entry in your configuration file defines what you like to install, any installation arguments, and the tags you like to use to group it together with other entries.

The schema for the config file can be found [here](docs/config-schema.md).

All the different things that you can install are defined in the [functions](functions/) folder. Take a look at the `README.md` for each of the function entries to see how to add them to your configuration file and what options to pass to it. The built-in functions includes the ability to install popular tools such as brew, Oh My Zsh (and plugins), Anaconda, NVM, Docker, and much more! If there is not an entry to install your favorite tool(s), it is easy to add a new entry - just run `./tools/create_function.sh entry_name` from the repository's root directory to get started.

### Install list file

Once you create a configuration file of how you like to install all of the items you like, the install list file is a simple text file that contains the exact entries you like to install. The goal of having this file is so you can pick which items you want to install without installing everything in your configuration file (perhaps you have different tools you like to use at work vs on your personal computer).

The schema for the install list text file can be found [here](docs/install-list-schema.md).

### Running the program

To install your config, run the install script from the repo's root directory. Here is what the command would look like if you want to install my config:

```shell
./install.sh -c configs/nathaniel/config.toml -f configs/nathaniel/install_list.txt -e -r
```

- The `-c` and `-f` arguments are required and respectively set the configuration and install list files
- `-e` runs it in strict mode (will fail and exit immediately if a step fails)
- `-r` runs zsh after all of the installation is done so you can see the changes without restarting the terminal (I am bias towards zsh, but hope to make this installer a bit less opinionated in the future)

## Other Cool Features

### Sudo permissions

One of the problems with setting up your computer is determining whether a given script needs sudo permission. Alfa will properly call sudo for the commands that require root permission and will run everything else in user mode. You will only be prompted for your password immediately upon running the install script; and then, the sudo permissions will be refreshed in the background as long as the installer is running.

This means that having your setup script pause halfway through because the sudo permissions timed out is a thing of the past. This was especially annoying for installing brew packages (since it requires sudo permissions, but does not allow you to call brew with sudo).

## Contributing

If you have any ideas on how to improve this, I would be happy for your contribution. Here is the [Contributing](CONTRIBUTING.md) guidelines for more information.
