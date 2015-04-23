defmodule HMC5883L.EventHandlerWatcher do
  use GenServer
  require Logger


  def start_link(_) do
    :ok
  end

  def init(_) do
    start_handler
    {:ok, {}}
  end

  def handle_info({:gen_event_EXIT, handler, reason}, state)
      when reason in [:normal, :shutdown] do
    {:stop, reason, state}
  end

  def handle_info({:gen_event_EXIT, handler, reason}, state) do
    Logger.warn("HMC5883L.EventHandler exited with reason: #{reason}. restarting...")

    start_handler
    {:noreply, state}
  end

  def handle_info({:stop, reason}, state) do
    {:stop, reason, state}
  end

  def handle_info(msg, state) do
    Logger.info("Unexpected message received: #{inspect msg}")

    {:noreply, state}
  end

  defp start_handler do
    :ok = GenEvent.add_handler(HMC5883L.Utilities.event_manager, HMC5883L.EventHandler, [])
  end
end

defmodule HMC5883L.EventHandler do
  alias HMC5883L.State
  import HMC5883L.Utilities
  require Logger

  def init(_) do
    {:ok, {}}
  end

  def handle_event(event, state), do: process_event(event, state)

  defp process_event({:error, error}, state) do
    Logger.warn("Driver error #{error}")

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

  defp process_event({type, _} = event, state) when type in [:heading, :available, :calibrated] do
    HMC5883L.State.update(event)

    {:ok, state}
  end

  defp process_event({type, msg},state) when is_atom(type) do
    Logger.warn("Unknown event received.\nType: #{type}\nMsg: #{inspect msg}")

    {:ok, state}
  end

  defp process_event(event, state) do
    Logger.warn("Unknown event received.\n#{inspect event}")

    {:ok, state}
  end
end
