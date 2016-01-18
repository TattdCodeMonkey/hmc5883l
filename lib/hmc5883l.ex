defmodule HMC5883L do
  use Application

  @doc """
  Starts the HMC5883L application

  Runs i2c driver to poll heading from compass
  """
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(HMC5883L.Supervisor, [])
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Returns the last decoded magentic heading reading in decimal degrees.

  Defaults to 0.0 on application statup
  """
  #@spec heading :: number
  #def heading, do: HMC5883L.State.heading

  @doc """
  Returns if the compass driver is currently running
  The compass driver is the process that reads from the i2c bus
  and decodes readings into a heading
  """
  #@spec available? :: boolean
  #def available?, do: HMC5883L.State.available?

  @doc """
  Returns the currently configured gain settings.

  Gain for all channels on the device (X, Y & Z) in either sensor field range or LSb / Gauss values.

  Choose a lower gain value when total field strength causes overflow in one of the data output registers (saturation). Note that the very first measurement after a gain change maintains the same gain as the previous setting.

  Sensor Field Range| Gain (LSb / Gauss) | Digital Resolution (Scale) mG /LSb
  ---|---|---|
  ±0.88|1370|0.73
  ±1.3|1090|0.92 (Default)
  ±1.9|820|1.22
  ±2.5|660|1.52
  ±4.0|440|2.27
  ±4.7|390|2.56
  ±5.6|330|3.03
  ±8.1|230|4.35

  """
  #@spec gain :: number
  #def gain, do: HMC5883L.State.gain

end
