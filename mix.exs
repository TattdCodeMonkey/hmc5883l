defmodule Hmc5883l.Mixfile do
  use Mix.Project

  def project do
    [app: :hmc5883l,
     version: "0.1.0",
     elixir: "~> 1.0",
     deps: deps,
     package: package()]
  end

  def application do
    [
      applications: [:logger],
      env: [board: :pi, i2c: [], compass: []],
      registered: [:hmc5883l]
    ]
  end

  defp deps do
    [
      {:multidef, "~>0.2"},
      {:dialyze, "~> 0.1.3", optional: true}
#     {:elixir_ale, "~>0.2"}
    ]
  end

  defp package() do
    [files: ["lib", "mix.exs", "README.md", "LICENSE"],
      contributors: ["Rodney Norris"],
      licenses: ["Apache 2.0"],
      links: [{"Github", "https://github.com/tattdcodemonkey/hmc5883l"}]]
  end
end
