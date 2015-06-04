defmodule Hmc5883l.Mixfile do
  use Mix.Project

  def project do
    [app: :hmc5883l,
     version: "0.3.0",
     elixir: "~> 1.0",
     deps: deps ++ deps(operating_system),
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

  defp package() do
    [files: ["lib", "mix.exs", "README.md", "LICENSE"],
      contributors: ["Rodney Norris"],
      licenses: ["Apache 2.0"],
      links: [{"Github", "https://github.com/tattdcodemonkey/hmc5883l"}]]
  end

  defp deps do
    [
      {:mon_handler, "~>1.0"},
      {:multidef, "~>0.2"},
      {:dialyze, "~> 0.1.4", optional: true},
      {:excoveralls, github: 'parroty/excoveralls', only: [:dev, :test]},
      {:shouldi, only:  [:dev, :test]}
    ]
  end

  defp deps("Linux") do
    [
      {:elixir_ale, "~>0.3"}
    ]
  end

  defp deps("Darwin") do
    []
  end

  defp deps(_) do
    []
  end

  def operating_system do
    case Application.get_env(:ada_imu, :operating_system) do
      nil ->
        Port.open({:spawn, "uname"}, [])

        os = receive do
          {_port, {:data, result}} -> result
          error -> error
        end

        result = os
        |> to_string
        |> String.replace("\n", "")

        :application.set_env(:ada_imu, :operating_system, result)

        result
      os_value -> os_value
    end
  end
end
