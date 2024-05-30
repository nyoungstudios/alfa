# pacman_packages

Configuration for a `pacman_packages` entry.

## Description

Installs pacman packages.

## Options

Accepts any number of arguments.

- all arguments are passed after the `pacman -Sy --noconfirm` command

## Example

```toml
[ pacman_packages ]
options = [
  "jq",
  "vim"
]
```
