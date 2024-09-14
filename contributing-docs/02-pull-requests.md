# Pull Requests

## Getting Started

If you have a bug fix, performance improvement, feature addition, documentation improvement, etc. that could be useful for this respository, I would be happy to have your have your contribution. First, make sure that there does not already exist a similar pending pull request. To create a pull request, please create a fork of this repo on GitHub.

## Opening a pull request

When you are ready to open a pull request, please try to name your PR title appropriately and follow the format from the [Conventional Commits guidelines](https://www.conventionalcommits.org/en/v1.0.0):

```bash
<type>(optional scope): description
```

While we do not have an automated changelog yet, I still think it is a good standard to go by. For the pr `type`, feel free to use any of these options:

- `feat`: for adding a feature
- `fix`: for resolving a bug
- `build`: relating to building the executable
- `ci`: relating to the CI (in our case, GitHub actions)
- `docs`: for documentation
- `style`: for coding style
- `refactor`: for refactoring code
- `perf`: for performance improvements
- `test`: for testing
- `chore`: for anything else

And for the `scope`, please use these options if relevant (otherwise, please omit the scope):

- `core`: changes relating to the main Dart program and `install.sh` script. Also, its related tests and documentation.
- `functions`: changes to the functions folder
- `configs`: adding/modifying a config in the configs folder

In your PR description, please include what you changed, any testing you did, and reference any issue that it resolves. See [this GitHub guide](https://docs.github.com/en/issues/tracking-your-work-with-issues/linking-a-pull-request-to-an-issue) on how to link a pull request to an issue.
