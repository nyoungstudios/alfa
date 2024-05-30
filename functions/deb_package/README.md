# Deb Package

Configuration for a `deb_package` entry.

## Description

Installs a single deb package.

## Options

Accepts exactly 1 argument.

- argument 1 is the url to download the deb file

## Example

```toml
[ deb_package ]
options = [
  "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
]
```
