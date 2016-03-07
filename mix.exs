defmodule Hmc5883l.Mixfile do
  use Mix.Project

  def project do
    [app: :hmc5883l,
     version: "0.5.0",
     elixir: ">= 1.0.0 and < 2.0.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     description: description,
     package: package,
    ]
  end

  def application do
    [
      applications: [:logger],
      env: [],
      registered: [:hmc5883l],
      mod: {HMC5883L, []}
    ]
  end

  defp package do
    [files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Rodney Norris"],
      licenses: ["Apache 2.0"],
      links: [{"Github", "https://github.com/tattdcodemonkey/hmc5883l"}]]
  end

  def description, do: """
  OTP application for reading the HMC5883L magnetometer.

  Magnetic heading is read at approx. 13hz (every 75ms)
  """

  defp deps do
    [
      {:mon_handler, "~>1.0"},
      {:multidef, "~>0.2"},
      {:dialyze, "~> 0.1.4", optional: true},
      {:shouldi, "~> 0.3", only:  [:dev, :test]}
    ] ++ additional_deps(Mix.env)
  end

  defp additional_deps(:test), do: []
  defp additional_deps(_), do: [
    {:elixir_ale, "~>0.4"}
  ]

end
