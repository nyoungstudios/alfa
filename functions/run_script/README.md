# Run Script

Configuration for a `run_script` entry.

## Description

Clones a git repo to a specified parent folder, and it will create the folder if it does not exist already. Additionally, it can run any set of commands or scripts within the repo's directory to setup its dependencies. Another use case could be to run your dotfile scripts.

## Options

Accepts any number of arguments.

- argument 1 is the file path to the folder
- argument 2 is the git url to clone
- each argument afterwards is a command/script to be run

## Environment Variables

`ALFA_REMOVE_REPO` - set to true or 1 if you want to remove the repo directory after cloning and running the commands. Default is false.

## Example

```toml
[ run_script ]
options = [
  "~/Documents/git-projects",
  "https://github.com/nyoungstudios/ascii-minesweeper",
  "make dev"
]

[ run_script.env ]
ALFA_REMOVE_REPO = false
```
