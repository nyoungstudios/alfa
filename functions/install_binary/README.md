# Install Binary

Configuration for an `install_binary` entry.

## Description

Installs a binary file in a specified bin folder. Optionally downloads the binary file from the internet if it is a URL.

## Options

Accepts exactly 1 argument.

- argument 1 is the URL to download the binary file from or the local filepath to the binary file

## Environment Variables

`ALFA_INSTALL_BINARY_NAME` - The name of the installed binary file. Defaults to basename of the URL or local filepath.
`ALFA_INSTALL_BINARY_BIN_DIR` - The directory to install the binary file. Defaults to `/usr/local/bin`.
`ALFA_INSTALL_BINARY_PERMISSIONS` - The permissions to set for the binary file. Defaults to `755`.

## Example

```toml
[ install_binary ]
options = [
  "https://example.com/path/to/binary"
]

[ install_binary.env ]
# these would be the defaults in this example
ALFA_INSTALL_BINARY_NAME = "binary"
ALFA_INSTALL_BINARY_BIN_DIR = "/usr/local/bin"
ALFA_INSTALL_BINARY_PERMISSIONS = "755"
```
