defmodule HMC5883L.Supervisor do
  @moduledoc """
  """
  use Supervisor

  defp name, do: __MODULE__

  @spec start_link() :: Supervisor.on_start
  def start_link, do: Supervisor.start_link(__MODULE__, [], [])

  @spec init(term) :: :ignore | {:ok, term}
  def init(_) do
    config = HMC5883L.CompassConfiguration.load_from_env

    [
      worker(HMC5883L.State, [config]),
      supervisor(HMC5883L.EventSupervisor, []),
      supervisor(HMC5883L.CompassSupervisor, [])
    ]
    |> supervise([strategy: :one_for_one, name: name])
  end
end
