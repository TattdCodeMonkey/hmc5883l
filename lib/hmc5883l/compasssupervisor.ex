defmodule HMC5883L.CompassSupervisor do
  @moduledoc """
  """

  use Supervisor
  
  def start_link(hdgSrv) do
    {:ok, _pid} = Supervisor.start_link(__MODULE__,hdgSrv)
  end

  def init(hdgSrv) do
    #state.config.i2c_channel,state.config.i2c_devid
    i2cConfig = %{i2c_channel: "i2c-1", i2c_devid: 0x1e,  scale_value: 1.3}
    child_processes = [ worker(HMC5883L.Server, [hdgSrv, I2c, i2cConfig]) ]
    supervise child_processes, strategy: :one_for_one
  end
end
