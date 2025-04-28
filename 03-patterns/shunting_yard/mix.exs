defmodule ShuntingYard.MixProject do
  use Mix.Project

  def project do
    [
      app: :shunting_yard,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
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
    ]
  end

  defp aliases do
    [
      trace: ["test --trace --seed 0"],
      cover: ["test --cover"],
      check: [
        "format --check-formatted",
        "compile --warnings-as-errors",
        "trace"
      ]
    ]
  end

  def cli do
    [
      preferred_envs: [
        trace: :test,
        cover: :test,
        check: :test,
      ]
    ]
  end
end
