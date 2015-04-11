defmodule HMC5883L.CompassSupervisor do
  alias I2c
  @moduledoc """
  """
  #TODO: import elixir_ale so that I2c on line 15 points to something

  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init(_) do
    server_config = HMC5883L.State.config
    child_processes = [
      worker(I2c, [server_config.i2c_channel, server_config.i2c_devid, name: HMC5883L.Utilities.i2c_name]),
      worker(HMC5883L.Driver, [[server_config]])
    ]
    supervise(child_processes, strategy: :one_for_all)
  end
end
