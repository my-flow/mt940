defmodule Mt940.Mixfile do
  use Mix.Project

  def project do
    [
      app: :mt940,
      version: "1.1.2",
      elixir: "~> 1.3",
      description: description(),
      package: package(),
      deps: deps(),
      name: "MT940/MT942 Parser",
      source_url: "https://github.com/my-flow/mt940",
      dialyzer: [plt_add_deps: true],
      test_coverage: [tool: ExCoveralls],
      consolidate_protocols: false
    ]
  end


  def application do
    [applications: [:logger]]
  end


  defp deps do
    [
      {:credo,       "~> 0.5.3",  only: [:dev, :test]},
      {:decimal,     "~> 1.3.1" },
      {:earmark,     "~> 1.0.3",  only: :dev, override: true},
      {:excoveralls, "~> 0.5.7",  only: :test},
      {:exjsx,       "~> 3.2.1",  only: [:dev, :test]},
      {:ex_doc,      "~> 0.14.3", only: :dev},
      {:inch_ex,     "~> 0.5.5",  only: :docs},
      {:timex,       "~> 3.1.5"},
      {:tzdata,      "~> 0.1.8",  override: true}
    ]
  end


  defp description do
    """
    MT940/MT942 parser for Elixir.
    """
  end


  defp package do
    [
      files:       ["lib", "priv", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Florian J. Breunig"],
      licenses:    ["MIT"],
      links:       %{"GitHub" => "https://github.com/my-flow/mt940"}
    ]
  end
end
