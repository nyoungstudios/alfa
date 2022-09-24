#!/bin/bash

# Usage: ./tools/create_function.sh entry_name

set -eu

if [[ ! -f "install.sh" ]]; then
  echo "create_function.sh must be run from the root directory of the alfa repo"
  exit 1
fi

if [[ -z "$1" ]]; then
  echo "must past the entry name as the first argument"
  exit 1
fi

folder="functions/$1"

if [[ -f "$folder/install.sh" || -f "$folder/config.toml" || -f "$folder/README.md" ]]; then
  echo "an entry with the name \"$1\" already exists"
  exit 1
fi

# create config.toml
mkdir -p "$folder"
echo "install_function = \"install_$1\"" > "$folder/config.toml"

# create install.sh
SCRIPT=$(cat << EOF
#!/bin/bash

install_$1() {

}
EOF
)
echo "$SCRIPT" > "$folder/install.sh"
chmod +x "$folder/install.sh"

# create README.md
README=$(cat << EOF
# $1

Configuration for a \`$1\` entry.

## Description

Installs $1.

## Options

Put what the arguments mean here

## Example

\`\`\`toml
[ $1 ]
options = []
\`\`\`
EOF
)
echo "$README" > "$folder/README.md"

echo "Created an entry with name $1 in $folder"
