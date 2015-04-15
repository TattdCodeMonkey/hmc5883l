defmodule HMC5883L.State do
  @name __MODULE__

  def start_link(config) do
    Agent.start_link(fn -> init(config) end, name: @name)
  end

  def get, do: Agent.get(@name, &(&1))

  def heading, do: get |> Map.get(:heading, 0.0)

  def calibrated?, do: get |> Map.get(:calibrated, false)

  def config, do: get |> Map.get(:config, %{})

  def gain, do: config |> Map.get(:gain, 1.3)

  def update({type, %{} = value}) when is_atom(type) do
    Agent.update(@name, &Map.merge(&1, value))
  end

  def update({type, value}) when is_atom(type) do
    Agent.update(@name, &Map.update(&1, type, value, fn(_) -> value end))
  end

  defp init(config) do
    %{heading: 0.0, calibrated: false, config: config}
  end
end
