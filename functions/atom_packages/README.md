# Atom Packages

Configuration for an `atom_packages` entry.

## Description

Installs atom packages.

## Options

Accepts any number of arguments.

- each argument is an atom package to install
- local package directories are linked with `apm link`

## Example

```toml
[ atom_packages ]
options = [
  "./path/to/local/atom-package"
]
```
