# Install Oh My Zsh Plugins

Configuration for an `install_ohmyzsh_plugins` entry.

## Description

Downloads Oh My Zsh plugins and saves them to your Oh My Zsh custom plugins folder.

## Options

Accepts any number of arguments.
- each argument is a git url to clone the Oh My Zsh plugin from

## Example

```toml
[ install_ohmyzsh_plugins ]
options = [
  "https://github.com/zsh-users/zsh-autosuggestions"
]
```
