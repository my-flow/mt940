defmodule Mt940.Mixfile do
  use Mix.Project

  def project do
    [
      app: :mt940,
      version: "0.1.0",
      elixir: "~> 1.0",
      description: description,
      package: package,
      deps: deps
    ]
  end


  def application do
    [applications: [:logger]]
  end


  defp deps do
    []
  end


  defp description do
    """
    MT940 parser for Elixir.
    """
  end


  defp package do
    [
      files:        ["lib", "priv", "mix.exs", "README*", "readme*", "LICENSE*", "license*"],
      contributors: ["Florian J. Breunig"],
      licenses:     ["MIT"],
      links:        %{"GitHub" => "https://github.com/my-flow/mt940"}
    ]
  end
end
