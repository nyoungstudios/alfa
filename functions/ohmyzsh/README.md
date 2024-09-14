# Oh My Zsh

Configuration for a `ohmyzsh` entry.

## Description

Installs Oh My Zsh.

## Options

Accepts exactly 0 arguments

## Environment Variables

The Oh My Zsh [install script](https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) respects these environment variables, and thus, they can be set in your config here.

`ZDOTDIR` - path to Zsh dotfiles directory (default: unset). See documentation below.

- <https://zsh.sourceforge.io/Doc/Release/Parameters.html#index-ZDOTDIR>
- <https://zsh.sourceforge.io/Doc/Release/Files.html#index-ZDOTDIR_002c-use-of>

`ZSH` - path to the Oh My Zsh repository folder (default: `$HOME/.oh-my-zsh`)

`REPO` - name of the GitHub repo to install from (default: `ohmyzsh/ohmyzsh`)

`REMOTE` - full remote URL of the git repo to install (default: GitHub via HTTPS)

`BRANCH` - branch to check out immediately after install (default: `master`)

## Example

```toml
[ ohmyzsh ]
options = []

# optionally configure environment variables
[ ohmyzsh.env ]
ZSH = "~/.custom-oh-my-zsh"
```
