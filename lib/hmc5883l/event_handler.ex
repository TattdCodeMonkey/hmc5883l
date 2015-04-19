defmodule HMC5883L.EventHandler do
  use GenEvent
  alias HMC5883L.State
  import HMC5883L.Utilities
  require Logger

  def start_link do
    case GenEvent.start_link(name: event_manager) do
      {:ok, pid} ->
        :ok = GenEvent.add_handler(pid, __MODULE__, [])
        {:ok, pid}
      {:error, {:already_started, _pid}} ->
        :ignore
    end
  end

  def init(_) do
    {:ok, {}}
  end

  def handle_event({type, msg} = event, state) when is_atom(type) do
    result = process_event(event)

    event |> check_logging

    result
  end

  defp process_event({:error, error}, state) do
    Logger.warn "Driver error #{error}"
    {:ok, state}
  end

  defp process_event({:raw_reading, msg}, state) do
    {x, y, z} = msg
    sx = x * state.scale
    sy = y * state.scale
    sz = z * state.scale

    {sx, sy, sz}
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

  defp process_event({:calibrated, _}, state) do
    {:ok, state}
  end

  defp process_event({:add_log, {type, freq}}, state) when is_atom(type) and is_number(freq) do
    add_logging(type, freq)

    {:ok, state}
  end

  defp process_event({:add_log, type}, state) do
    add_logging(type, 1)

    {:ok, state}
  end

  defp process_event({:rem_log, type}, state) when is_atom(type) do
    rem_logging(type)

    {:ok, state}
  end

  defp process_event({type, msg},state) when is_atom(type) do
    Logger.warn("Unknown event received.\nType: #{type}\nMsg: #{msg}")

    {:ok, state}
  end

  defp add_logging(type, freq), do: State.add_event_logging(type, freq)

  defp rem_logging(type), do: State.remove_event_logging(type)

  defp check_logging(event) do
    el = State.event_logging

    case Map.get(el, type, false) do
      false -> :ok
      log_int -> handle_logging(event, log_int, event_logging)
    end
  end

  defp handle_logging(event, {freq, cnt}, el) do
    {type, _} = event

    new_cnt = cnt + 1
    case rem(new_cnt, freq) do
      0 ->
        new_cnt = 0
        event |> log_event
      _ -> :ok
    end

    Map.update(state.event_logging, type, {1,1}, fn(_) -> {freq, new_cnt} end)
    |> State.update_event_logging
  end

  defp log_event(event) do
    event |> inspect |> Logger.info
  end
end
