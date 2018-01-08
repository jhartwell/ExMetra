defmodule ExMetra.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ex_metra,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      package: package()
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
      {:httpoison, "~> 0.13"},
      {:poison, "~> 3.0"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package do
    [
      description: description(),
      licenses: ["MIT"],
      maintainers: ["Jon Hartwell"],
      links: %{"GitHub" => "https://github.com/jhartwell/ExMetra"}
    ]
  end

  defp description do
    """
      ExMetra is a wrapper for the Chicago Metra's (Chicago commuter light rail) JSON API.
    """
  end
end
