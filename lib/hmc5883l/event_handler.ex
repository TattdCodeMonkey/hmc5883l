defmodule HMC5883L.EventHandler do
  use GenEvent
  alias HMC5883L.State
  import HMC5883L.Utilities
  require Logger

  def start_link do
    case GenEvent.start_link(name: event_manager) do
      {:ok, pid} ->
        :ok = GenEvent.add_handler(pid, __MODULE__, [])
        :ok = GenEvent.add_handler(pid, HMC5883L.LoggingEventHandler, [])
        {:ok, pid}
      {:error, {:already_started, _pid}} ->
        :ignore
    end
  end

  def init(_) do
    {:ok, {}}
  end

  def handle_event(event, state), do: process_event(event, state)

  defp process_event({:error, error}, state) do
    Logger.warn "Driver error #{error}"
    {:ok, state}
  end

  defp process_event({:raw_reading, msg}, state) do
    {x, y, z} = msg

    scale = State.scale

    sx = x * scale
    sy = y * scale
    sz = z * scale

    {:scaled_reading, {sx, sy, sz}}
    |> notify

    {:ok, state}
  end

  defp process_event({:scaled_reading, msg}, state) do
    {x, y, _z} = msg

    heading = :math.atan2(y,x) |> bearing_to_degrees

    {:heading, heading} |> notify

    {:ok, state}
  end

  defp process_event({:heading, _} = event, state) do
    HMC5883L.State.update(event)

    {:ok, state}
  end
  
  defp process_event({:available, _} = event, state) do
    HMC5883L.State.update(event)

    {:ok, state}
  end

  defp process_event({:calibrated, _}, state) do
    {:ok, state}
  end

  defp process_event({:add_log, _}, state), do: {:ok, state}

  defp process_event({:rem_log, _}, state), do: {:ok, state}

  defp process_event({type, msg},state) when is_atom(type) do
    Logger.warn("Unknown event received.\nType: #{type}\nMsg: #{inspect msg}")

    {:ok, state}
  end

end
