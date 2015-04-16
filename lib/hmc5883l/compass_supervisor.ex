defmodule HMC5883L.CompassSupervisor do
  alias I2c
  @moduledoc """
  """
  #TODO: import elixir_ale so that I2c on line 15 points to something

  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, [])
  end

  def init(_) do
    server_config = HMC5883L.State.config
    i2c_confg = HMC5883L.I2cConfiguration.load_from_env
    child_processes = [
      worker(I2c, [i2c_confg.channel, i2c_confg.dev_id, [name: HMC5883L.Utilities.i2c_name]]),
      worker(HMC5883L.Driver, [[server_config, I2c]])
    ]
    supervise(child_processes, strategy: :one_for_all)
  end
end
