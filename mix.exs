defmodule Hmc5883l.Mixfile do
  use Mix.Project

  def project do
    [app: :hmc5883l,
     version: "0.2.0",
     elixir: "~> 1.0",
     deps: deps,
     test_coverage: [tool: ExCoveralls],
     package: package()
    ]
  end

  def application do
    [
      applications: [:logger],
      env: [board: :pi, i2c: [], compass: []],
      registered: [:hmc5883l],
      mod: {HMC5883L, []}
    ]
  end

  defp deps do
    [
      {:elixir_ale, "~>0.3"},
      {:multidef, "~>0.2"},
      {:dialyze, "~> 0.1.4", optional: true},
      {:excoveralls, only: [:dev, :test]},
      {:shouldi, only:  [:dev, :test]}
    ]
  end

  defp package() do
    [files: ["lib", "mix.exs", "README.md", "LICENSE"],
      contributors: ["Rodney Norris"],
      licenses: ["Apache 2.0"],
      links: [{"Github", "https://github.com/tattdcodemonkey/hmc5883l"}]]
  end
end
