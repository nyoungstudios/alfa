# apk_packages

Configuration for an `apk_packages` entry.

## Description

Installs apk packages.

## Options

Accepts any number of arguments.
- all arguments are passed after the `apk add --no-interactive` command

## Example

```toml
[ apk_packages ]
options = [
  "jq",
  "vim"
]
```
