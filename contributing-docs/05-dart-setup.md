# Dart Setup

The main program and test framework is written in the Dart programming language. This guide contains how to setup your Dart development environment.

It does not really matter what editor you use; however, if you want to contribute to the Dart codebase and do not want to set up Dart on your local machine, you can use a containerized development environment with all of the requirements built-in. Here are two options:

1. **Gitpod**. This repo has a Gitpod config already setup, so all you have to do is visit: <https://gitpod.io/#https://github.com/nyoungstudios/alfa>. Or replace my GitHub url with your fork.
2. **VS Code's dev container**. In order to use this, clone your fork to your local machine and follow this [setup guide](https://code.visualstudio.com/docs/remote/containers) before opening the folder in VS Code. In short, you will need to install Docker and the [VS Code Remote Containers extension](https://aka.ms/vscode-remote/download/containers). Finally, when opening the repo in VS Code, it will prompt you to open it in the dev container. Then, it will build the Docker image with all the dependencies needed.

To build the Dart executable, just run `make` from the repository's root directory. It will build and appropriately rename the executable to what the `install.sh` script expects.
