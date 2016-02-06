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
end
