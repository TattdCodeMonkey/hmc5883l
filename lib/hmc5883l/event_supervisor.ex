defmodule HMC5883L.EventSupervisor do
  use Supervisor

  def start_link, do: Supervisor.start_link(__MODULE__, [])

  def init(_) do
    [
      worker(GenEvent, [[name: HMC5883L.Utilities.event_manager]]),
      worker(MonHandler, [MonHandler.get_config(HMC5883L.Utilities.event_manager, HMC5883L.EventHandler, []), []])
    ]
    |> supervise(strategy: :one_for_all)
  end
end
