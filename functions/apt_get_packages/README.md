# Apt Get Packages

Configuration for an `apt_get_packages` entry.

## Description

Installs apt-get packages.

## Options

Accepts any number of arguments.

- all arguments are passed after the `apt-get install -y` command

## Example

```toml
[ apt_get_packages ]
options = [
  "--no-install-recommends",
  "curl",
  "jq"
]
```
