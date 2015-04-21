defmodule HMC5883L.LoggingEventHandler do
  use GenEvent
  require Logger

  def handle_event({type, _msg} = event, state) do
    event_logging = State.event_logging

    case Map.get(event_logging, type, false) do
      false -> :ok
      log_int -> handle_logging(event,log_int, event_logging)
    end

    process_event(event)

    {:ok, state}
  end

  defp handle_logging(event, {freq, cnt}, event_logging) do
    {type, _} = event
    new_cnt = cnt + 1
    case rem(new_cnt, freq) do
      0 ->
        new_cnt = 0
        event |> log_event
      _ -> :ok
    end

    Map.update(event_logging, type, {1,1}, fn(_) -> {freq, new_cnt} end)
    |> State.update_event_logging
  end

  defp log_event(event) do
    event |> inspect |> Logger.info
  end

  defp process_event({:add_log, {type, freq}}) when is_atom(type) and is_number(freq) do
    Logger.debug("Added event logging for #{type}, every #{freq} event will be logged")

    State.add_event_logging(type, freq)
  end

  defp process_event({:add_log, type}) do
    Logger.debug("Added event logging for #{type}, every event will be logged")

    State.add_event_logging(type, 1)
  end

  defp process_event({:remove_log, type}) when is_atom(type) do
    Logger.debug("Remvoed event logging for #{type}")

    State.remove_event_logging(type)
  end
end
