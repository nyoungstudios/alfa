# Install List Schema

This lays out the schema for the `install_list.txt` file that can be passed to the `install.sh` script with the `-f` argument. This text file contains the references to the names and tag names in the `config.toml` file of the things you want to install. And they will be installed in the order that you list them in. It does not take into account what things are already installed on your machine or what dependencies each entry might have.

## General Schema

Each entry in the install list text file should be separated by a new line. Leading and trailing whitespace will automatically be removed. And you can comment out items using `#` or `//`.

If this is our `config.toml` file:

```toml
[ name ]
tags = []

[ name2 ]
tags = []

[ item1 ]
tags = [ "custom" ]

[ item2 ]
tags = [ "custom" ]
```

Then, our `install_list.txt` file could look something like this:

```txt
name
// commented out lines will be skipped
// name2
custom
```

And in this case, only these items would be installed:

```txt
name
item1
item2
```
