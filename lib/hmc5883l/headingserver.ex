defmodule HMC5883L.HeadingServer do
  use GenServer

  #####
  # External API

  def start_link(), do: {:ok, _pid} = GenServer.start_link(__MODULE__, _init(), name: __MODULE__)

  def update_state(pid, state), do: GenServer.cast(pid, {:update_state, state})

  def update_value(pid, value), do: GenServer.cast(pid, {:update_value, value})

  def get_value(pid), do: GenServer.call(pid, {:get_value})

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

  def terminate(reason, state) do
    #TODO: Do something here?
    :ok
  end
  #####
  # private method
  defp _init(), do: %{heading: 0.0, state: :unknown}

end
