# Snap Package

Configuration for a `snap_package` entry.

## Description

Installs a single snap package.

## Options

Accepts any number of arguments.
- all arguments are passed after the `snap install` command

## Example

```toml
[ snap_package ]
options = [
  "kubectl",
  "--classic"
]
```
