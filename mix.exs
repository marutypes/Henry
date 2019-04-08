defmodule Henry.MixProject do
  use Mix.Project

  def project do
    [
      app: :henry,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
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
      {:yaml_elixir, "~> 2.1.0"},
      {:earmark, "~> 1.3.2"},
      {:mustachex, "~> 0.0.2"},
      {:slugify, "~> 1.1"},
      {:timex, "~> 3.1"},
      # We need this to allow escript builds with timex
      # See https://hexdocs.pm/timex/Timex.html#module-timex-with-escript
      {:tzdata, "~> 0.1.8", override: true}
    ]
  end

  defp escript do
    [main_module: Henry.CLI]
  end
end
