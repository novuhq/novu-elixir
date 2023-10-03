# CONTRIBUTING

Contributions are welcome, and are accepted via pull requests.
Please review these guidelines before submitting any pull requests.

## Process

1. Fork the project
1. Create a new branch
1. Code, test, commit and push
1. Open a pull request detailing your changes. Make sure your PR title follows [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).

## Guidelines

* Please ensure the coding format by running `mix format`.
* You may need to [rebase](https://git-scm.com/book/en/v2/Git-Branching-Rebasing) to avoid merge conflicts.
* Please remember that we follow [SemVer](http://semver.org/).

## Setup

Clone your fork, then install the dependencies:

```bash
mix deps.get
```

## Format

Format your code:
```bash
mix format
```

## Lint

Lint your code with credo and dialyxir:
```bash
mix credo
mix dialyzer
```

## Tests

Run all tests:
```bash
mix test
```

## Releasing

The release process of this repository is automated as much as possible to ensure there isn't a bottle neck, or merged PRs waiting to be deployed. Once a PR is merged it into `main`, a secondary PR will be created or updated with a title like so: `chore(main): release <version>`. This PR will include all of the needed changes for a new release, including an updated `CHANGELOG.md` file, increasing the version in `mix.exs`, and updating any documentation. Once a maintainer merged that PR in, a new release will be created in GitHub and pushed to [hex.pm](https://hex.pm/packages/novu).
