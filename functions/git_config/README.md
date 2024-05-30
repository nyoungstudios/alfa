# Git Config

Configuration for a `git_config` entry.

## Description

Sets the git user name and git user email attributes. And creates a ssh key which you can copy to GitHub or other git hosting sites.

## Options

Accepts exactly 2 arguments

- argument 1 is the git user name
- argument 2 is the git user email

## Example

```toml
[ git_config ]
options = [
  "username",
  "user@email.com"
]
```
