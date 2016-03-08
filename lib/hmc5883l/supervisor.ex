defmodule HMC5883L.Supervisor do
  @moduledoc """
  """
  use Supervisor

  defp name, do: __MODULE__

  @spec start_link() :: Supervisor.on_start
  def start_link, do: Supervisor.start_link(__MODULE__, [], [name: name])

  def init(_) do
    Enum.map(Application.get_env(:hmc5883l, :sensors), &sensor_sup/1)
    |> supervise([strategy: :one_for_one])
  end

  defp sensor_sup(sensor) do
    supervisor(HMC5883L.SensorSupervisor, [sensor])
  end
end
