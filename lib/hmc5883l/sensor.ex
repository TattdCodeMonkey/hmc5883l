defmodule HMC5883L.Sensor do
  use GenServer
  require Logger

  def start_link(args, opts \\ []) do
  	res = {:ok, pid} = GenServer.start_link(__MODULE__, args, opts)

  	Process.send_after(pid, :initialize, read_interval)

  	res
  end

  def init(args) do
  	HMC5883L.SensorState.init(args.state_name)

  	{:ok, args}
  end

  #####
  # GenServer implementation
  def handle_cast(:initialize, state) do
    state = initialize!(state)
    {:noreply, state}
  end

  def handle_cast(:read_heading, state) do
    state = read_heading!(state)
    {:noreply, state}
  end

  def handle_info(:timed_read, state) do
    timed_read()
    read_heading!(state)
    {:noreply, state}
  end

  def handle_info(:initialize, state) do
    state = initialize!(state)
    {:noreply, state}
   end

  def handle_info(msg, state) do
    Logger.warn("Unknown msg received #{inspect(msg)}")
    {:noreply, state}
  end

  def code_change(_old_vsn, state, _extra) do
    {:ok, state}
  end

  def terminate(_reason, state) do
    terminated(state)
    :ok
  end

  ####
  # Private
  defp initialize!(state) do
  	Logger.debug("Initializing #{state.sensor.name} HMC5883L Sensor")

  	#write config. TODO: Change these for configured values
    {:ok, state} = write_config!(state)
    #read heading
    {:ok, state} = read_heading!(state)
    #set timer for reading header
    timed_read()
    initialized(state)

    state
  end

  defp write_config!(%{i2c_name: nil} = state) do 
  	encoded_config = HMC5883L.InterfaceControl.encode_config(state.config)
	Logger.debug "Write config #{inspect state.config} - #{inspect encoded_config}"

  	{:ok, state} 
  end
  defp write_config!(%{i2c_pid: nil} = state) do
  	case Process.whereis(state.i2c_name) do
    	nil -> {:ok, state}
    	pid ->
    		state01 = %{state | i2c_pid: pid}
    		write_config!(state01)
    end
  end
  defp write_config!(state) do
  	:ok = GenServer.call(state.i2c_pid, {:write, <<0x00>> <> HMC5883L.InterfaceControl.encode_config(state.config)})

  	{:ok, state}
  end

  defp read_heading!(%{i2c_name: nil} = state) do 
    notify({:raw_reading, {0,0,0}}, state)

  	{:ok, state}
  end
  defp read_heading!(%{i2c_pid: nil} = state) do
    case Process.whereis(state.i2c_name) do
    	nil -> {:ok, state}
    	pid ->
    		state01 = %{state | i2c_pid: pid}
    		read_heading!(state01)
    end
  end
  defp read_heading!(state) do
  	#{:wrrd, write_data, read_count}
  	GenServer.call(state.i2c_pid, {:wrrd, <<0x03>>, 6})
  	|> HMC5883L.InterfaceControl.decode_heading
  	|> notify(state)

  	{:ok, state}
  end

  defp read_interval, do: 75
  defp timed_read, do: Process.send_after(self(), :timed_read, read_interval)
  defp initialized(state), do: notify({:available, true}, state)
  defp terminated(state), do: notify({:available, false}, state)

  defp notify(msg, state) do 
  	
  	GenEvent.notify(state.event_mgr, msg)
  end
end