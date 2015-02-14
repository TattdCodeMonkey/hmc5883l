defmodule HMC5883L do
  use Application
  alias HMC5883L.Supervisor

  @doc """
  Starts the application by starting HMC5883L.Supervisor.
  """
  def start(_type, _args) do
    Supervisor.start_link()
  end
end

