defmodule Mt940.Mixfile do
  use Mix.Project

  def project do
    [
      app: :mt940,
      version: "1.0.0",
      elixir: "~> 1.2.4",
      description: description,
      package: package,
      deps: deps,
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
      {:decimal,     "~> 1.1.1" },
      {:exjsx,       "~> 3.2.0",  only: [:dev, :test]},
      {:excoveralls, "~> 0.5.2",  only: [:dev, :test]},
      {:earmark,     "~> 0.2.1",  only: :dev},
      {:ex_doc,      "~> 0.11.4", only: :dev},
      {:inch_ex,     "~> 0.5.1",  only: :docs},
      {:timex,       "~> 2.1.4"},
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
