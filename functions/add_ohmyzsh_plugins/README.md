# Add Oh My Zsh Plugins

Configuration for an `add_ohmyzsh_plugins` entry.

## Description

Modifies your `.zshrc` file to define which Oh My Zsh plugins to load.

## Options

Accepts any number of arguments.
- each argument is the plugin name. They can either be built-in plugins or custom plugins

## Example

```toml
[ add_ohmyzsh_plugins ]
options = [
  "git",
  "zsh-autosuggestions"
]
```
