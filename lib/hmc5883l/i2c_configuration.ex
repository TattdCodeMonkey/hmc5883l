defmodule HMC5883L.I2cConfiguration do
  defstruct channel: "", dev_id: 0x00
  alias __MODULE__
  @type t :: %I2cConfiguration{channel: String.t, dev_id: byte}

  @default_channel "i2c-1"
  @default_id 0x1E

  @spec new :: t
  def new, do: new(@default_channel)
  
  @spec new(String.t) :: t
  def new(channel), do: new(channel, @default_id) 

  @spec new(String.t, byte) :: t
  def new(channel, id), do: %I2cConfiguration{channel: channel, dev_id: id}

  @spec load_from_env :: t
  def load_from_env do
   Application.get_env(:hmc5883l, :i2c) 
   |> Enum.reduce(new, &load_config_value/2)
  end

  defp load_config_value({:channel, channel}, config) when is_binary(channel), do: %{config | channel: channel}
  defp load_config_value({:devid, id}, config), do: load_device_id(id, config)
  defp load_config_value({:dev_id, id}, config), do: load_device_id(id, config)
  defp load_config_value({:id, id}, config), do: load_device_id(id, config)
  defp load_config_value(_, config), do: config

  defp load_device_id(id, config) when is_number(id) and id > 0 and id < 128, do: %{config | dev_id: id}
  defp load_device_id(_, config), do: config
end
