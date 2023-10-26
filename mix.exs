defmodule Novu.MixProject do
  use Mix.Project

  @source_url "https://github.com/novuhq/elixir"
  @version "0.3.0"

  def project do
    [
      app: :novu,
      description: "Elixir SDK for Novu",
      deps: deps(),
      docs: docs(),
      elixir: "~> 1.11",
      name: "Novu",
      package: package(),
      elixirc_paths: elixirc_paths(Mix.env()),
      source_url: @source_url,
      start_permanent: Mix.env() == :prod,
      version: @version
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:req, "~> 0.4.4"},
      {:elixir_uuid, "~> 1.2"},

      # Development Dependencies
      {:bypass, "~> 2.1", override: true, only: :test},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:doctor, "~> 0.19", only: [:dev, :test]},
      {:ex_doc, "~> 0.27", only: [:dev, :test], runtime: false}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    [
      files: ~w(lib mix.exs CHANGELOG.md CONTRIBUTING.md README.md LICENSE),
      licenses: ["MIT"],
      links: %{
        Website: "https://novu.co/",
        Changelog: "#{@source_url}/releases",
        GitHub: @source_url
      }
    ]
  end

  defp docs do
    [
      main: "readme",
      logo: "priv/assets/logo.png",
      extras: [
        "README.md": [filename: "readme", title: "Readme"],
        "CONTRIBUTING.md": [filename: "contributing", title: "Contributing"],
        "CHANGELOG.md": [filename: "changelog", title: "Changelog"]
      ]
    ]
  end
end
