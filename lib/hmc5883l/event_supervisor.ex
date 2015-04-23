defmodule HMC5883L.EventSupervisor do
  use Supervisor

  def start_link, do: Supervisor.start_link(__MODULE__, [])

  def init(_) do
    [
      worker(GenEvent, [name: HMC5883L.Utilities.event_manager]),
      worker(HMC5883L.EventHandlerWatcher, [])
    ]
    |> supervise(strategy: :one_for_all)
  end
end
