# Git Clone

Configuration for a `git_clone` entry.

## Description

Clones any number of git repos to a specified parent folder. Will create the folder if it does not exist already.

## Options

Accepts any number of arguments.
- argument 1 is file path to the folder
- each argument afterwards is the git url to clone

## Example

```toml
[ git_clone ]
options = [
  "~/Documents/git-projects",
  "https://github.com/facebook/create-react-app.git"
]
```
