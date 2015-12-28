defmodule HMC5883L.State do

  defp name, do: __MODULE__

  def start_link(config) do
    Agent.start_link(fn -> init(config) end, name: name)
  end

  def get, do: name |> get
  def get(pid), do: Agent.get(pid, &(&1))

  def heading, do: name |> heading
  def heading(pid), do: pid |> get |> Map.get(:heading, 0.0)

  def available?, do: name |> available?
  def available?(pid), do: pid |> get |> Map.get(:available, false)

  def config, do: name |> config
  def config(pid), do: pid |> get |> Map.get(:config, %{})

  def gain, do: name |> gain
  def gain(pid), do: pid |> config |> Map.get(:gain, 1.3)

  def axis_gauss, do: name |> axis_gauss
  def axis_gauss(pid), do: pid |> config |> Map.get(:gauss, {1090, 980})

  def update(data) do
    name |> update(data)
  end

  def update(pid, {type, %{} = value}) when is_atom(type) do
    Agent.update(pid, &Map.merge(&1, value))
  end

  def update(pid, {type, value}) when is_atom(type) do
    Agent.update(pid, &Map.update(&1, type, value, fn(_) -> value end))
  end

  defp init(config) do
    %{heading: 0.0, available: false, config: config}
  end
end
