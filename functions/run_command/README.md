# Run Command

Configuration for a `run_command` entry.

## Description

Runs a shell command with arguments.

## Options

Accepts any number of arguments.

- argument 1 is command to run
- each argument afterwards is passed to the command

## Environment Variables

There are no special environment variables, but you can pass any environment variables to use in your commmand.

## Example

```toml
[ run_command ]
options = [
  "bash",
  "-ceu",
  "pwd && echo Hi $NAME"
]

[ run_command.env ]
NAME = "Maverick"
```
