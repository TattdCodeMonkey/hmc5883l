defmodule HMC5883L.Driver do
  use GenServer
  alias I2c
  require Logger

  @read_interval 200

  #####
  # External API
  def start_link(config) do
    {:ok, pid} = GenServer.start_link(__MODULE__, config, name: __MODULE__)
    Process.send_after(pid,:initialize, @read_interval)
    {:ok, pid}
  end

  #####
  # GenServer implementation
  def init([config, i2c]) do
    i2c_pid = HMC5883L.Utilities.i2c_name |> Process.whereis
    {:ok , %{config: config, i2c: i2c, i2c_pid: i2c_pid}}
  end

  def handle_cast(:initialize, state) do
    state = initialize!(state)
    {:noreply, state}
  end

  def handle_cast(:calibrate, state) do
    state = calibrate(state)
    {:noreply, state}
  end

  def handle_cast(:read_heading, state) do
    state = read_heading!(state)
    {:noreply, state}
  end

  def handle_info(:timed_read, state) do
    read_heading!(state)
    time_read()
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

  def terminate(_reason, _state) do
    terminated
    :ok
  end

  #####
  # private methods
  defp initialize!(state) do
    Logger.debug("initializing hmc5883l i2c driver")

    #write config. TODO: Change these for configured values
    :ok = write_config!(state)
    #read heading
    read_heading!(state)
    #set timer for reading header
    time_read()
    initialized
    state
  end

  defp time_read(), do: Process.send_after(self(),:timed_read, @read_interval)

  defp read_heading!(state) do
    bearing_degrees = read_heading_from_i2c!(state)
    {:heading, bearing_degrees} |> notify
  end

  defp calibrate(state) do

    state
  end

  defp write_config!(state) do
    I2c.write(state.i2c_pid,<<0x00>> <> HMC5883L.InterfaceControl.encode_config(state.config))
  end

  # defp write_mode!(state, value) do
  #   state.i2c.write(state.i2c_pid, <<0x02>> <> InterfaceControl.encode_modereg(value))
  #
  #   config = state.config
  #   config = %{config| mode: value}
  #   #TODO: update config to be saved somewhere??
  #   state  = %{state| config: config}
  #   state
  # end

  # defp write_gain!(state, gain) do
  #   state.i2c.write(state.i2c_pid, <<0x01>> <> InterfaceControl.encode_cfgb(gain))
  #   config = state.config
  #   config = %{config| gain: gain, scale: Utilities.get_scale(gain)}
  #   #TODO: update config to be saved somewhere??
  #   state  = %{state| config: config}
  #   state
  # end

  defp read_heading_from_i2c!(state) do
    #write 0x03 then read 6 bytes
    I2c.write_read(state.i2c_pid, <<0x03>>, 6)
    |> HMC5883L.InterfaceControl.decode_heading(state.config.scale)
  end

  defp initialized, do: {:available, true} |> notify

  # defp calibrated, do: {:calibrated, true} |> notify

  defp terminated, do: {:available, false} |> notify

  defp notify(msg), do: GenEvent.notify(HMC5883L.Utilities.event_manager, msg)
end
