# Code Style

It is important to maintain consistent coding style. This repository uses GitHub Action checks to validate that all code contributions pass the style checks. Part of the style checks are validated with [pre-commit](https://pre-commit.com). You do not need to install pre-commit locally when developing as it should be easy enough to identify the style problems by using the appropriate IDE extensions. The pre-commit checks do automatically fix a handful of style related problems, so here is how to run them locally if you like.

```bash
# install pre-commit
pip install pre-commit

# run the checks
pre-commit run --all-files
```

## General

This respository uses EditorConfig to define the number of spaces for indentation as well as removing excess white characters. If your editor does not come bundled with native support, you can install the appropriate EditorConfig extension. For more information, please visit their [website](https://editorconfig.org).

## Markdown

This repository uses [markdownlint](https://github.com/DavidAnson/markdownlint) to standardize the formatting of Markdown files. If you are using VS Code, you can install the [extension](https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint) so that warning messages will appear when something does not follow the standard.

## Dart

Additionally, if you are contributing to the Dart codebase, this repo includes a VS Code `settings.json` file with the recommended Dart editor guidelines in addiiton to the Dart linting rules defined in `analysis_options.yaml`. To run the Dart linter, you can run `dart analyze` (or `make lint`). And to apply the automated linting changes, run `dart fix --apply` (or `make fix`).
