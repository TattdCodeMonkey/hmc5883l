defmodule HMC5883L.State do
  @name __MODULE__

  def start_link(config) do
    Agent.start_link(fn -> init(config) end, name: @name)
  end

  def get, do: Agent.get(@name, &(&1))

  def heading, do: get |> Map.get(:heading, 0.0)

  def calibrated?, do: get |> Map.get(:calibrated, false)

  def available?, do: get |> Map.get(:available, false)

  def config, do: get |> Map.get(:config, %{})

  def gain, do: config |> Map.get(:gain, 1.3)

  def event_logging, do: get |> Map.get(:event_logging)

  def add_event_logging(type, freq) do
    Agent.update(@name, &Map.update(&1, :event_logging, %{},
      fn(el) ->
        el
        |> Map.update(type, {freq,0}, fn({_cF, it}) -> {freq,it} end)
      end))
  end

  def update_event_logging(el) do
    Agent.update(@name, &Map.update(&1, :event_logging, el, fn(_)-> el end))
  end

  def remove_event_logging(type) do
    Agent.update(@name, &Map.update(&1, :event_logging, %{}, 
      fn(el) ->
        el
        |> Map.delete(type)
      end))
  end

  def update({type, %{} = value}) when is_atom(type) do
    Agent.update(@name, &Map.merge(&1, value))
  end

  def update({type, value}) when is_atom(type) do
    Agent.update(@name, &Map.update(&1, type, value, fn(_) -> value end))
  end

  defp init(config) do
    %{heading: 0.0, available: false, calibrated: false, config: config, event_logging: Map.new}
  end
end
