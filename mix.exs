defmodule Novu.MixProject do
  use Mix.Project

  @source_url "https://github.com/novuhq/elixir"
  @version "0.1.0"

  def project do
    [
      app: :novu,
      description: "Elixir SDK for Novu",
      deps: deps(),
      docs: docs(),
      elixir: "~> 1.11",
      name: "Novu",
      package: package(),
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
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}

      # Development Dependencies
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.27", only: [:dev, :test], runtime: false}
    ]
  end

  defp package do
    [
      files: ~w(lib mix.exs README.md LICENSE),
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
      extras: ["README.md"]
    ]
  end
end
