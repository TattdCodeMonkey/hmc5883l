defmodule HMC5884L.Server do
  use GenServer

  @read_interval 5000
  
  #####
  # External API
  def start_link(config) do
    {:ok, pid} = GenServer.start_link(__MODULE__, config, name: __MODULE__)
    GenServer.cast pid, :initialize
    {:ok, pid}
  end

  #####
  # GenServer implementation
  def init([hdgSrv, i2cMod, i2c_config]) do
    {:ok , %{heading_srv: hdgSrv, i2c: i2cMod, config: i2c_config}}
  end

  def handle_cast({:initialize}, state) do
    state = initialize(state)
    {:noreply, state}
  end

  def handle_cast({:calibrate}, state) do
    state = calibrate(state)
    {:noreply, state}
  end

  def handle_cast({:read_heading}, state) do
    state = read_heading(state)
    {:noreply, state}
  end

  def handle_info(:timed_read, state) do
    state = read_heading(state)
    time_read()
    {:noreply, state}
  end

  def handle_info(_msg, state), do: {:noreply, state}

  def code_change(_old_vsn, state, _extra) do
    {:ok, state}
  end

  def terminate(reason, state) do
    #TODO: Do something here?
    :ok
  end
  #####
  # private methods
  defp initialize(state) do
    #start link to i2c
    {:ok, i2cPid} = state.i2c.start_link(state.config.i2c_channel,state.config.i2c_devid)
    state = %{state| i2c_pid: i2cPid}
    #write config. TODO: Change these for configured values
    write_config(state, <<0b01110000, 0b00100000, 0x00>>) 
    #read heading
    state = read_heading(state)
    #set timer for reading header
    time_read()
    initialized(state)
    state
  end

  defp time_read(), do: Process.send_after(self(),:timed_read, @read_interval) 
  
  defp read_heading(state) do
    bearingDegrees = read_heading_from_i2c(state)
    state = %{state| heading: bearingDegrees}
    update_heading(state)
    state
  end

  defp calibrate(state) do
    
    state
  end
  
  defp write_config(state, <<_,_,_>> = cfgBytes) do
    state.i2c.write(state.i2c_pid,0x00,cfgBytes)
  end 

  defp write_mode(state, value) do
    state.i2c.write(state.i2c_pid, 0x02, <<value>>)
  end

  defp write_scale(state, scale) do
    state.i2c.write(state.i2c_pid, 0x01, <<scale>>)
  end

  defp read_heading_from_i2c(state) do
    state.i2c.write(state.i2c_pid,0x03)
    :timer.sleep(1)
    <<x_raw :: size(16), z_raw :: size(16), y_raw :: size(16)>> =
      state.i2c.read(state.i2c_pid, 6)
    x_out = x_raw * state.config.scale_value
    y_out = y_raw * state.config.scale_value
    z_out = z_raw * state.config.scale_value

    :math.atan2(y_out,x_out)
    |> bearingToDegrees    
  end

  defp bearingToDegrees(rBearing) when rBearing < 0 do
    rBearing + (2 * :math.pi)
    |> bearingToDegrees
  end
  defp bearingToDegrees(rBearing) do
    rBearing * (180 / :math.pi)
  end 
  ## Send data to HeadingServer
  defp update_heading(state) do
    HeadingServer.update_value(state.heading_srv, state.heading)
  end

  defp initialized(state) do
    HeadingServer.update_state(state.heading_srv, :initialized)
  end

  defp calibrated(state) do
    HeadingServer.update_state(state.heading_srv, :calibrated)
  end
end