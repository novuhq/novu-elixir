# Novu

[![CI](https://github.com/novuhq/elixir/actions/workflows/ci.yml/badge.svg)](https://github.com/novuhq/elixir/actions/workflows/ci.yml)

An Elixir SDK for [Novu](https://novu.co/).

## Installation

Novu is available on [hex.pm](https://hex.pm/packages/novu). Just add this line to your `mix.exs` file:

<!-- {x-release-please-start-version} -->
```elixir
def deps do
  [
    {:novu, "~> 0.2.0"}
  ]
end
```
<!-- {x-release-please-end} -->

## Documentation

Documentation is available on [HexDocs](https://hexdocs.pm/novu/readme.html).

## Contributing

First off, thank you for for showing an interest in contributing to the Elixir SDK for Novu!

### Coding guidelines

To ensure consistency throughout the source code, please ensure all code contributed follows the ELixir formatter rules. These are checked on every PR submitted so you will get warnings if the code is unformatted before it's merged in.

### Documentation

Documentation is generated using `ex_doc` and published to [HexDocs](https://hexdocs.pm/novu/readme.html) on new releases. This is automatic, so our only ask is ensure public functions have proper documentation and examples provided.

### Pull Requests

Pull requests of all kinds are welcome! Before you open a PR, you will want to ensure your PR title follows [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) format. This lets us automate SemVer versions for release, as well as generate helpful changelog entries. When a PR is submitted, our GitHub actions will ensure the code compiles and tests pass in the latest versions of Elixir, the code follows formatting rules, as well as credo and dialyzer pass.

### Releasing

The release process of this repository is automated as much as possible to ensure there isn't a bottle neck, or merged PRs waiting to be deployed. Once a PR is merged it into `main`, a secondary PR will be created or updated with a title like so: `chore(main): release <version>`. This PR will include all of the needed changes for a new release, including an updated `CHANGELOG.md` file, increasing the version in `mix.exs`, and updating any documentation. Once a maintainer merged that PR in, a new release will be created in GitHub and pushed to [hex.pm](https://hex.pm/packages/novu).
