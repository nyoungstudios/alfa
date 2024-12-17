# Install Binary

Configuration for an `install_binary` entry.

## Description

Installs a binary file in a specified bin folder.

## Options

Accepts exactly 1 argument.

- argument 1 is the URL to download the binary file from

## Environment Variables

`ALFA_INSTALL_BIN_DIR` - The directory to install the binary file. Defaults to `/usr/local/bin`.
`ALFA_INSTALL_PERMISSIONS` - The permissions to set for the binary file. Defaults to `755`.

## Example

```toml
[ install_binary ]
options = [
  "https://example.com/path/to/binary"
]

[ install_binary.env ]
ALFA_INSTALL_BIN_DIR = "/usr/local/bin"
ALFA_INSTALL_PERMISSIONS = "755"
```
