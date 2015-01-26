defmodule HMC5883L.HeadingServer do
  use GenServer

  #####
  # External API
  def start_link(), do: {:ok, _pid} = GenServer.start_link(__MODULE__, _init(), name: __MODULE__)

  @doc """
    Updates the current state, should only be called by Compass server.
  """
  @spec update_state(pid, atom) :: Tuple
  def update_state(pid, state), do: GenServer.cast(pid, {:update_state, state})

  @doc """
    Updates the current heading value, should only be called by the Compass server.
  """
  @spec update_value(pid, number) :: Tuple
  def update_value(pid, value), do: GenServer.cast(pid, {:update_value, value})

  @doc """
    Returns the current heading value in decimal degrees.
  """
  @spec get_value(pid) :: float
  def get_value(pid), do: GenServer.call(pid, {:get_value})

  @doc """
    Returns the current state of the driver.

    :unknown     - initial state
    :initialized - Compass is configured and reading
    :calibrated  - Compass offsets have been calibrated
    :error       - Compass server terminated, and has not successfully restarted
  """
  @spec get_state(pid) :: atom
  def get_state(pid), do: GenServer.call(pid, {:get_state})

  #compass lost?

  #####
  # GenServer Implementation

  def handle_call({:get_value}, _from, current_state), do: {:reply, current_state.heading, current_state }

  def handle_call({:get_state}, _, current_state), do: {:reply, current_state.state, current_state}

  def handle_cast({:update_value, value}, current_state) do
    current_state = %{current_state| heading: value}
    {:noreply, current_state}
  end

  def handle_cast({:update_state, state}, current_state) do
    current_state = %{current_state| state: state}
    {:noreply, current_state}
  end

  def terminate(_reason, _state) do
    #TODO: Do something here?
    :ok
  end
  #####
  # private method
  defp _init(), do: %{heading: 0.0, state: :unknown}

end
