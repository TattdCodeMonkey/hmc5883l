defmodule HMC5883L.EventHandler do
  use GenEvent
  alias HMC5883L.State
  import HMC5883L.Utilities
  require Logger

  def init(args) do
    {:ok, args}
  end

  def handle_event(event, args) do
    process_event(event)

    {:ok, args}
  end

  defp process_event({:error, error}), do: Logger.warn("Driver error #{error}")

  defp process_event({:raw_reading, msg}) do
    {x, y, z} = msg

    scale = State.scale

    sx = x * scale
    sy = y * scale
    sz = z * scale

    {:scaled_reading, {sx, sy, sz}}
    |> notify
  end

  defp process_event({:scaled_reading, msg}) do
    {x, y, _z} = msg

    heading = :math.atan2(y,x) |> bearing_to_degrees

    {:heading, heading}
    |> notify
  end

  defp process_event({type, _} = event)
    when type in [:heading, :available] do
    HMC5883L.State.update(event)
  end

  defp process_event({type, msg})
    when is_atom(type) do
    Logger.warn("Unknown event received.\nType: #{type}\nMsg: #{inspect msg}")
  end

  defp process_event(event) do
    Logger.warn("Unknown event received.\n#{inspect event}")
  end
end
