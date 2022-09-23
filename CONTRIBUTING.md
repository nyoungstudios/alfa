# Contributing Guidelines

Any contribution is welcome and appreciated! :)

## Issues

### For a Problem

If you have a problem, take a look at the existing issues and if you find a similar one, please leave a comment it. Otherwise, feel free to open a new issue. If you open a new issue, please include the following items:

1. The problem you are experiencing
2. How to reproduce the problem
3. What the expected behavior should be

### For a Suggestion

If you have a suggestion, take a look at the existing issues and if you find a similar one, please leave a comment on it. Otherwise, feel free to open a new issue. A well defined description of the improvement is appreciated.

## Pull Requests

### Getting Started

If you have a bug fix, performance improvement, feature addition, documentation imrpovement, etc. that could be useful for this respository, I would be happy to have your have your contribution. First, make sure that there does not already exist a similar pending pull request. To create a pull request, please create a fork of this repo on GitHub.

### Coding

It does not really matter what editor you use; however, if you want to contribute to the Dart codebase and do not want to set up Dart on your local machine, you can use a containerized development environment with all of the requirements built-in. Here are two options:

1. Gitpod. This repo has a Gitpod config already setup, so all you have to do is visit: https://gitpod.io/#https://github.com/nyoungstudios/alfa. Or replace my GitHub url with your fork.
2. VS Code's dev container. In order to use this, clone your fork to your local machine and follow this [setup guide](https://code.visualstudio.com/docs/remote/containers) before opening the folder in VS Code. In short, you will need to install Docker and the [VS Code Remote Containers extension](https://aka.ms/vscode-remote/download/containers). Finally, when opening the repo in VS Code, it will prompt you to open it in the dev container. Then, it will build the Docker image with all the dependencies needed.

To build the Dart executable, just run `make` from the repository's root directory. Then, run the `./rename.sh` script to rename the executable to the filename the `install.sh` script expects.

### Style

This respository uses EditorConfig to define the number of spaces for indentation as well as removing excess white characters. A lot of editors come bundled with native support, but if not you can always install an EditorConfig extension. For more information, visit their [website](https://editorconfig.org). Additionally, if you are using VS Code and are contributing to the Dart codebase, this repo includes a `settings.json` file with the recommended Dart style guidelines.

### Testing

To test your code, it is important to run it in a clean and reproducable environment. In other words, you do not want to have something in your local environment affecting your testing. For example, running it in a Docker image like this should work out well:

```bash
# running from the repository's root directory so that you can mount the codebase
docker run --rm -it --workdir $PWD -v "$PWD:$PWD" --entrypoint bash ubuntu:20.04
```

If need to test your code in a full desktop environment, I would recommend creating a virtual machine with qemu and virt-manager. Here is a good [article](https://www.how2shout.com/linux/how-to-install-qemu-kvm-and-virt-manager-gui-on-ubuntu-20-04-lts) on how to do that.

And if you need to test out your code on macOS, I recommend creating a virtual machine with the guidelines from this [repository](https://github.com/sickcodes/Docker-OSX). Also, take a look at the bash script [here](tools/optimize.sh) to make your macOS virtual machine run smoother.

### Opening your PR

Now you are ready to open your pull request. For the PR title, please try to follow the format from the [Conventional Commits guidelines](https://www.conventionalcommits.org/en/v1.0.0):

```bash
<type>: description
```

While we do not have an automated changelog yet, I still think it is a good standard to go by. Also, this project is not really large enough to have scopes, so you can leave that part out, but for the `type`, feel free to use these options (except for `build` as that is mostly the same as the `ci` in this case):

- `feat`: for adding a feature
- `fix`: for resolving a bug
- `ci`: relating to the CI (in our case, GitHub actions or Codemagic)
- `docs`: for documentation
- `style`: for coding style
- `refactor`: for refactoring code
- `perf`: for performance improvements
- `test`: for testing
- `chore`: for anything else

In your PR description, please include what you changed, any testing you did, and reference any issue that it resolves. See [this GitHub guide](https://docs.github.com/en/issues/tracking-your-work-with-issues/linking-a-pull-request-to-an-issue) on how to link a pull request to an issue.