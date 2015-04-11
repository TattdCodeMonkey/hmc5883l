defmodule HMC5883L do
  use Application

  @doc """
  Starts the HMC5883L application

  Runs i2c driver to poll heading from compass
  """
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    config = HMC5883L.CompassConfiguration.load_from_env
    children = [
      worker(HMC5883L.State, [config]),
      supervisor(HMC5883L.Supervisor, [])
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end

  def heading, do: HMC5883L.State.heading

  def calibrated?, do: HMC5883L.State.calibrated
  def available?, do: false
  def gain, do: HMC5883L.State.gain

  def add_event_handler(), do: {:ok}
  def del_event_handler(), do: {:ok}

end
