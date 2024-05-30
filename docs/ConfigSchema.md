# Config Schema

This lays out the schema for the `config.toml` file that can be passed to the `install.sh` script with the `-c` argument. The config file is your definition of how you like each of the functions to be run.

## General Schema

Here is the general schema for each entry. The `name` field is required. And all of its nested keys are optional. If you do not want to pass any values to these optional keys, set at least one key to an empty array `[]` so the toml file will still be parsed correctly.

```toml
[ name ]
tags = []
os = []
options = []
env = {}
```

### Name

The `name` field refers any of the folder names in the [functions](../functions/) directory. Read the `README.md` file within each of the folders and/or take a look at the `install.sh` file to see what any given entry does upon being called. The name field in your config is also what you would put in the install list file (passed with the `-f` argument in the `install.sh` script). Alternatively, you can always write a more friendly name in the `tags` array. See the next section for more detail on that.

If you like to call a function more than once, but with different options; then, you can append a plus sign after the name followed by a string to help you remember what that entry does (sort of like email address aliases). This is so we do not have duplicate keys within the dictionary in the toml file. For example, if we wanted to call the `apt_get_packages` function twice, we could do something like this.

```toml
[ "apt_get_packages+jq" ]
options = [
    "jq"
]

[ "apt_get_packages+neofetch" ]
options = [
    "neofetch"
]
```

### Tags

The `tags` field is useful if you like to group multiple entries together, especially if you always install certain packages together. Also, as mentioned previously, you can use the tag name to just create an easier to remember name. The tag name or the reference name can be used in the install list file to run the associated entries. Here is an example of grouping with tags:

```toml
[ do_something ]
tags = [ "utils" ]
options = [
    "arg1",
    "arg2"
]

[ another_thing ]
tags = [ "utils" ]
```

Then, specifying "utils" in the install list file will run the `do_something` function and then the `another_thing` function in that order.

### OS

The `os` field is useful for defining which operating system this entry will run on. For example, for the name, `apt_get_packages`, you would not need to specify that it only should run on Linux since that is already specified in the `dictionary.toml` file. However, if you want to install a certain brew package only on macOS (brew can run on both macOS and Linux); then, we would write our entry something like this.

```toml
[ brew_packages ]
os = [ "macos" ]
options = [
    "jq"
]
```

The os name can either be "macos" or "linux" - all lowercase.

### Options

The `options` field is an array of arguments that will be passed to the install function. For example, if the function is defined as this:

```sh
echo_stuff() {
  for line in "$@"
  do
    echo "$line"
  done
}
```

And we set the options as:

```toml
options = [
    "hi",
    "user"
]
```

It will print this to standard out:

```text
hi
user
```

### Env

The `env` field is a nested hash map of environment variables that will be passed to the install function. This may be ideal for setting optional arguments in the install function rather than using the positional arguments set in the `options` field. For example, if the function is defined as this:

```sh
echo_stuff() {
  echo "${NAME:-user}"
}
```

And we set the env as:

```toml
env = { NAME = "joe" }
```

It will print this to standard out:

```text
joe
```

However, if we do not set the env, it will print this to standard out:

```text
user
```
