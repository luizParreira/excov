defmodule Excov.Mixfile do
  use Mix.Project

  @description "Excov is a library that implements Markov Reinforcement Learning abstractions"
  @version "0.1.0"

  def project do
    [
      app: :excov,
      version: @version,
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env),
      build_embedded: Mix.env == :prod,
      source_url: "https://github.com/luizParreira/excov",
      docs: [extras: ["README.md"], main: "Excov"],
      deps: deps(),
      package: package()
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  def package do
    [
      maintainers: ["Luiz Parreira"],
      licenses: ["MIT"],
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      links: %{"GitHub" => "https://github.com/luizParreira/excov"}
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
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:csv, "~> 2.0.0"},
      {:ex_doc, "~> 0.14", only: :dev}
    ]
  end
end
