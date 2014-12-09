defmodule HMC5883L.Configuration do
  defstruct averaging: 8, data_rate: 15, bias: :normal, gain: 1.3, mode: :continuous, i2c_channel: 'i2c-1', i2c_devid: 0x1E 
  alias __MODULE__
  
  def new(), do: %Configuration{}

end 
