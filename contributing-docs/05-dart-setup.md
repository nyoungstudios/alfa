# Dart Setup

The main program and test framework is written in the Dart programming language. This guide contains how to setup your Dart development environment.

If you want to contribute to the Dart codebase and do not want to set up Dart on your local machine, you can use a containerized development environment ([dev container](https://containers.dev)) with all of the requirements built-in. There are many tools that can run a dev container; two of the more popular ones are:

1. **GitHub Codespaces**. This offers a development environment in your web browser. On the repository homepage (or your fork), click the green "Code" button and under the "Codespaces" tab, click the three dots button. Then, in the menu, click "New with options...". Finally, in the new tab, you should select which dev container configuration you want to use. Don't pick "Default project configuration". Instead pick "default" for most development or pick "with-docker" if you also want to use Docker in the Codespace. You can read the [GitHub documentation](https://docs.github.com/en/codespaces/quickstart) for more information.
2. **VS Code's dev container**. This offers the same experience as GitHub Codespaces, but with a locally built Docker image. In order to use this, clone the repository to your local machine and follow this [setup guide](https://code.visualstudio.com/docs/remote/containers) before opening the folder in VS Code. In short, you will need to install Docker and the [VS Code Remote Containers extension](https://aka.ms/vscode-remote/download/containers). Finally, when opening the repository in VS Code, it will prompt you to open it in the dev container. Then, it will build the Docker image with all the dependencies needed.

If you prefer to set up Dart on your local machine, I would recommend installing [mise](https://mise.jdx.dev) to manage your Dart versions. After cloning this repository, you can run `mise install` from within this project's root directory to install Dart.

It does not really matter what editor you use. If you like to use VS Code, the recommended Dart VS Code settings are included as part of this repository.

To build the Dart executable, just run `make` from the repository's root directory. It will build and appropriately name the executable to what the `install.sh` script expects.
