defmodule HMC5883L.CompassSupervisor do
  alias I2c
  @moduledoc """
  """
  #TODO: import elixir_ale so that I2c on line 15 points to something

  use Supervisor
  
  def start_link(hdg_srv) do
    {:ok, _pid} = Supervisor.start_link(__MODULE__,hdg_srv)
  end

  def init(hdg_srv) do
    #state.config.i2c_channel,state.config.i2c_devid
    server_config = HMC5883L.Configuration.load_from_env()    
    child_processes = [ worker(HMC5883L.Server, [[hdg_srv, I2c, server_config]])]
    supervise(child_processes, strategy: :one_for_one)
  end
end
