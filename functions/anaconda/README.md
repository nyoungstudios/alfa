# Anaconda

Configuration for an `anaconda` entry.

## Description

Installs Anaconda 3.

## Options

Accepts 0 or 1 arguments.

- argument 1 is the url to download the anaconda installer. If not specified explicitly, it will default to the latest installer for the respective operating system and architecture that it is running on

## Environment Variables

`ANACONDA_PREFIX` - The location to install Anaconda at. Defaults to `$HOME/anaconda3`.

## Example

```toml
[ anaconda ]
options = []

# optionally install Anaconda elsewhere
[ anaconda.env ]
ANACONDA_PREFIX = "/opt/anaconda3"
```
