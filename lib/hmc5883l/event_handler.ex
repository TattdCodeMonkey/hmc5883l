defmodule HMC5883L.EventHandler do
  use GenEvent
  require Logger

  def start_link do
    case GenEvent.start_link(name: HMC5883L.Utilities.event_manager) do
      {:ok, pid} ->
        :ok = GenEvent.add_handler(pid, __MODULE__, [])
        {:ok, pid}
      {:error, {:already_started, _pid}} ->
        :ignore
    end
  end

  def init(_), do: {:ok, {}}

  def handle_event({:error, error}, state) do
    Logger.warn "Driver error #{error}"
    {:ok, state}
  end

  def handle_event({:raw_reading, _}, state), do: {:ok, state}
  def handle_event({:scaled_reading, _}, state), do: {:ok, state}
  def handle_event({:calibrated, _}, state) do
    #TODO: save calibration offsets
    #   with calibration offsets saved, need to used them to adjust raw readings before scaling  
    {:ok, state}
  end
  def handle_event({type, _} = event,state) when is_atom(type) do
    HMC5883L.State.update(event)
    {:ok, state}
  end
end
