defmodule HMC5883L.Configuration do
  defstruct averaging: 8, data_rate: 15, bias: :normal, gain: 1.3, scale: 0.0, mode: :continuous, i2c_channel: "i2c-1", i2c_devid: 0x1E
  alias __MODULE__
  alias HMC5883L.Utilities
  @type t :: %Configuration{averaging: number, data_rate: number, bias: atom, gain: number, scale: number, mode: atom, i2c_channel: String.t, i2c_devid: byte}
  import MultiDef

  def new(), do: %Configuration{}

  @doc """
  Load a new %Configuration{} from the current enviroment variables.
  """
  def load_from_env() do
    new
    |> load_compass_config
    |> load_i2c_config
  end

  def load_compass_config(config) do
    Application.get_env(:hmc5883l, :compass)
    |> load_config_from_array(config)
    |> set_scale
  end

  def load_i2c_config(config) do
    Application.get_env(:hmc5883l, :i2c)
    |> load_config_from_array config
  end


  def load_config_from_array(values, config), do: values |> Enum.reduce(config, &load_config_val/2)

  mdef load_config_val do
    {:i2c_channel, chan}, config -> %{config| i2c_channel: chan}
    {:i2c_devid, id}, config     -> %{config| i2c_devid: id}
    {:gain, gain}, config -> %{config| gain: gain}
    {:mode, mode}, config -> %{config| mode: mode}
    {:bias, bias}, config -> %{config| bias: bias}
    {:data_rate, data_rate}, config -> %{config| data_rate: data_rate}
    {:averaging, avg}, config -> %{config| averaging: avg}
  end

 def set_scale(%Configuration{} = config), do: %{config| scale: config.gain |> Utilities.get_scale}

end
