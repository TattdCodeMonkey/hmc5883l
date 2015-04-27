defmodule HMC5883L.EventSupervisor do
  use Supervisor

  def start_link, do: Supervisor.start_link(__MODULE__, [])

  def init(_) do
    [
      worker(GenEvent, [[name: HMC5883L.Utilities.event_manager]]),
      supervisor(HMC5883L.HandlerSupervisor, [])
    ]
    |> supervise(strategy: :one_for_all)
  end
end

defmodule HMC5883L.HandlerSupervisor do
  use Supervisor

  def start_link, do: Supervisor.start_link(__MODULE__, [])

  def init(_) do
    [
      worker(HMC5883L.EventHandlerWatcher, [[]])
    ]
    |> supervise(strategy: :one_for_one)
  end
end
