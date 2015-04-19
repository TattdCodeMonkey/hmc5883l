defmodule HMC5883L.EventHandler do
  use GenEvent
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
    state = %{event_logging=>Map.new, scale=> 0.0}
    {:ok, state}
  end

  def handle_event({type, msg} = event, state) when is_atom(type) do
    case Map.get(state.event_logging, type, false) do
      false -> :ok
      log_int -> state = handle_logging(event,log_int, state)
    end

    process_event(event, state) 
  end
  
  defp handle_logging(event, {freq, cnt}, state) do
    {type, _} = event
    new_cnt = cnt + 1
    cond rem(new_cnt, freq) do
      0 -> 
        new_cnt = 0
        event |> log_event
      _ -> :ok
    end
    
    new_event_logging = state.event_logging
                        |> Map.update(type, {1,1}, fun(_) -> {freq, new_cnt} end) 

    %{state| event_logging=> new_event_logging}
  end
  
  defp log_event(event) do
    event |> inspect |> Logger.info
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
    new_state = add_logging(type, freq, state)

    {:ok, new_state}
  end

  defp process_event({:add_log, type}, state) do
    new_state = add_logging(type, 1, state)

    {:ok, new_state}
  end
 
  defp process_event({:rem_log, type}, state) when is_atom(type) do
    new_state = rem_logging(type, state) 
    {:ok, new_state}
  end
 
  defp process_event({type, msg},state) when is_atom(type) do
    Logger.warn("Unknown event received.\nType: #{type}\nMsg: #{msg}")

    {:ok, state}
  end

  defp add_logging(type, freq, state) do
    new_logging = state.event_logging |> 
      Map.update(type, {freq,0}, fn({_cF, it}) -> {freq,it} end)
    new_state = %{state| event_logging=> new_logging}
  end

  defp rem_logging(type, state) do
    new_logging = state.event_logging |>
      Map.delete(type)
    new_state = %{state| event_logging=> new_logging}  
  end
end
