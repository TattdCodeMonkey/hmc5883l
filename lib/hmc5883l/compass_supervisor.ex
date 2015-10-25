defmodule HMC5883L.CompassSupervisor do
  @moduledoc """
  """
  #TODO: import elixir_ale so that I2c on line 15 points to something

  use Supervisor

  def start_link, do: Supervisor.start_link(__MODULE__, [], [])

  def init(_) do
    server_config = HMC5883L.State.config
    i2c_config = HMC5883L.I2cConfiguration.load_from_env

    get_children(i2c_config, server_config)
    |> supervise(strategy: :one_for_all)
  end

  def get_children(i2c_config,server_config) do
    if Code.ensure_loaded?(I2c) do
      [
        worker(I2c, [i2c_config.channel, i2c_config.dev_id, [name: HMC5883L.Utilities.i2c_name]]),
        worker(HMC5883L.Driver, [[server_config, I2c]])
      ]
    else
      [
        worker(HMC5883L.Driver, [[server_config, MockI2c]])
      ]
    end
  end
end
