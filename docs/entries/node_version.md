# Node Version

Configuration for a `node_version` entry.

## Description

Installs the latest Node version with NVM. Or can explicitly specify which Node version to install.

## Options

Accepts 0 or 1 arguments.
- If argument 1 is given, then it will explicitly install the given Node version. Otherwise, it will install the latest Node version

## Example

```toml
[ node_version ]
options = [
  "16.1.0"
]
```
