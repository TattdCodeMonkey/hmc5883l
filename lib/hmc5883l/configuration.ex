defmodule HMC5883L.Configuration do
  defstruct averaging: 8, data_rate: 15, bias: :normal, gain: 1.3, scale: 0.92, mode: :continuous, i2c_channel: "i2c-1", i2c_devid: 0x1E 
  alias __MODULE__
  @type t :: %Configuration{averaging: number, data_rate: number, bias: atom, gain: number, scale: number, mode: atom, i2c_channel: String.t, i2c_devid: byte} 

  def new(), do: %Configuration{}

end 
