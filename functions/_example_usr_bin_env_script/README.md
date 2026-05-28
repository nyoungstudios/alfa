# Example

Configuration for a `_example_usr_bin_env_script` entry.

## Description

This is a example function for demostration purposes. This example shows you can write the `install.sh` script using `/usr/bin/env` as the shebang to support shells installed in a non-standard location. Generally, we should use `sh` for the most compatibility like in `_example`.

## Options

Accepts any number of arguments.

- each argument is a printed to stdout

## Example

```toml
[ _example ]
options = [
  "arg1",
  "arg2"
]
```
