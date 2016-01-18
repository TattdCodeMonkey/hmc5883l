defmodule HMC5883L.SensorState do
  def init(name) do
  	case :ets.info(name) do
  		:undefined ->
  			^name = create_table(name)
  			init_table(name)
  			:ok
  		_ -> :ok
  	end
  end

  def create_table(name) do
  	:ets.new(name, [:set, :named_table, :public])
  end	

  def init_table(name) do
  	:ets.insert(name, [
  		available: false,
  		heading: nil,
  		raw: nil,
  		scaled: nil,
  		gain: 1.3,
  		axis_gauss: {1090, 980}
	])
  end

  def update(name, value), do: true = :ets.insert(name, value)

  def get(name, key), do: :ets.lookup(name, key) |> Enum.into(%{})
  def get(name), do: :ets.match_object(name, {:"$1", :"$2"}) |> Enum.into(%{})
  
  def available?(name), do: get(name, :available)
  def raw(name), do: get(name, :raw)
  def scaled(name), do: get(name, :scaled)
  def heading(name), do: get(name, :heading)
  def axis_gauss(name), do: get(name, :axis_gauss)
end