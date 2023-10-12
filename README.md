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

## Configuration

Some parameters are configurable for use during the execution of requests, typically in `config/config.exs`. The following variables can be configured:

```elixir
config :novu,
  api_key: "api_key",  # required: your api key
  domain: "domain",  # required: your domain
  wait_min: 1000,  # optional: the minimum time to retry a request is milliseconds (default: 1000)
  wait_max: 10_000,  # optional: the maximum time to retry a request is milliseconds (default: 10_000)
  max_retries: 3,  # optional: the amount of retries in case of responses 408/429/500/502/503/504 (default: 3)
  retry_log_level: :warning  # optional: the log level to emit retry logs at. Can be set to false do disable logging (default: :warning)
```

## Documentation

Documentation is generated using `ex_doc` and published to [HexDocs](https://hexdocs.pm/novu/readme.html) on new releases. This is automatic, so our only ask is ensure public functions have proper documentation and examples provided.

## Contributing

First off, thank you for for showing an interest in contributing to the Elixir SDK for Novu! We have created a [contributing guide](./CONTRIBUTING.md) that will show you how to setup a development environment and how to open pull requests.
