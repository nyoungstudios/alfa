# Vimrc

Configuration for a `vimrc` entry.

## Description

Installs the ultimate vimrc configuration.

## Options

Accepts 0 or 1 arguments.

- argument 1 is the git url to download ultimate vimrc configuration so that you can specific your fork. Otherwise, it defaults to the [original version](https://github.com/amix/vimrc/).

## Environment Variables

`SET_AS_GIT_EDITOR` - If set to `1` or `true`, it will set vim as the default git editor.

## Example

```toml
[ vimrc ]
options = [
  # optionally pass your fork like this
  # "https://github.com/myusername/vimrc/"
]

# optionally set vim as the default editor
[ vimrc.env ]
SET_AS_GIT_EDITOR = true
```
