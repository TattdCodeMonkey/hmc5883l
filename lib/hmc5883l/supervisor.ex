defmodule HMC5883L.Supervisor do
  @moduledoc """
  """
  use Supervisor

  @spec start_link() :: {atom, pid}
  def start_link, do: Supervisor.start_link(__MODULE__, [])

  def init(_) do
    config = HMC5883L.CompassConfiguration.load_from_env

    [
      worker(HMC5883L.State, [config]),
      supervisor(HMC5883L.EventSupervisor, []),
      supervisor(HMC5883L.CompassSupervisor, [])
    ]
    |> supervise([strategy: :one_for_one, name: __MODULE__])
  end
end
