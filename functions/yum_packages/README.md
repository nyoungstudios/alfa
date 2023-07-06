# yum_packages

Configuration for a `yum_packages` entry.

## Description

Installs yum packages.

## Options

Accepts any number of arguments.
- all arguments are passed after the `yum install -y` command

## Example

```toml
[ yum_packages ]
options = [
  "jq",
  "vim"
]
```
