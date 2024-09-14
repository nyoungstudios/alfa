# How to test functions

## Overview

To test a function, it is important to run it in a clean and reproducable environment. In other words, you do not want to have something in your local environment affecting your testing. For example, running your test in a Docker image like this should work out well:

```bash
# running from the repository's root directory so that you can mount the codebase
docker run --rm -it --workdir $PWD -v "$PWD:$PWD" --entrypoint bash ubuntu:22.04
```

## Automating tests

In order to automate our function tests, we have a GitHub Action workflow that runs on pull requests. Based off of the test runner config, you can set it up to run on a specific operating system or Docker image so that you can have an automated containerized test.

The test cases are defined in the test resource folder (`test/resources/functions`) with the folder name as the function name you want to write a test case for. There are two important files for your test case.

### Config file

The config toml file (`test_config.toml`) is the config passed to the `-c` option for the alfa program (`./install.sh`). To learn more about this file, please read [this page](../docs/config-schema.md).

### Test runner file

The test runner file (`runners.toml`) contains the configuration on how to run the test and what assertions should be done afterwards.

There are two main top level keys in the test runner file - `common` and `case`. The schema under `common` is the same schema as `case.<test case name>`. If a key isn't defined in `case.<test case name>`, it will inherit the value from `common`. In other words, `common` is for the shared settings whereas `case.<test case name>` are specific to that test case.

### Test runner file example

Here is an example test runner toml file:

```toml
[case.example]
os = "ubuntu-22.04"

install-tag = "install-tag"
setup-tag = "setup-tag"
teardown-tag = "teardown-tag"

[case.example.test]

assert-install-names = ["setup_function_name", "function_name", "teardown_function_name"]
assert-log-contains = ["log part 1", "log part 2"]

[[case.example.test.commands]]

command = "bash"
arguments = ["-ceu", "echo hi"]
assert-stdout-equals = "hi"
# assert-stderr-equals = ""
# assert-stderr-contains = ""
# assert-stdout-contains = ""

[[case.example.test.commands]]

command = "which"
arguments = ["whoami"]
assert-stdout-equals = "/usr/bin/whoami"
# assert-stderr-equals = ""
# assert-stderr-contains = ""
# assert-stdout-contains = ""
```

### Test runner file schema

- **os** (required) - this is the name of the GitHub Action Runner Image. In other words, this is the value passed to the `runs-on` key in the GitHub Action workflow. [Here is a list](https://github.com/actions/runner-images) of all available images.
- **install-tag** (optional) - this is the tag in the `test_config.toml` file which runs the function you are testing. This value defaults to the name of the function you are testing; however, if you would like to test the same function with different inputs, you case use this tag to identify each one individually.
- **setup-tag** (optional) - this is the tag in the `test_config.toml` file which runs before the function you are testing. This is useful if you need to install some dependencies prior to testing your function.
- **teardown-tag** (optional) - this is the tag in the `test_config.toml` file which runs after the function you are testing.
- **test** (optional) - all the keys relating to the making the assertions after the setup/install/teardown steps.
  - **assert-install-names** (optional) - the names of the keys in the `test_config.toml` file which were run.
  - **assert-log-contains** (optional) - a list of strings to check that was printed in the logs while running the setup/install/teardown steps.
  - **commands** (optional) - a list of any other commands to run for additional testing.
    - **command** (required) - a shell command to run in the containerized environment.
    - **arguments** (optional) - a list of arguments to pass to the command.
    - **assert-stdout-equals** (optional) - a string to check that the standard out of the command/arguments is equal to.
    - **assert-stderr-equals** (optional) - a string to check that the standard err of the command/arguments is equal to.
    - **assert-stdout-contains** (optional) - a string to check that the standard out of the command/arguments contains.
    - **assert-stderr-contains** (optional) - a string to check that the standard err of the command/arguments contains.

## Testing in a desktop environment

If need to test your code in a full desktop environment, I would recommend creating a virtual machine with qemu and virt-manager. Here is a good [article](https://www.how2shout.com/linux/how-to-install-qemu-kvm-and-virt-manager-gui-on-ubuntu-20-04-lts) on how to do that.

And if you need to test out your code on macOS, I recommend creating a virtual machine with the guidelines from this [repository](https://github.com/sickcodes/Docker-OSX). Also, take a look at the bash script [here](tools/optimize.sh) to make your macOS virtual machine run smoother.
