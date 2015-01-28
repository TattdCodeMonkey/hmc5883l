defmodule HMC5883L.Supervisor do
  @moduledoc """
  """
  use Supervisor

  @spec start_link() :: {atom, pid}
  def start_link() do
    result = {:ok, sup} = Supervisor.start_link(__MODULE__,[])
    start_workers(sup, [])
    result
  end

  def start_workers(sup, _) do
    #start heading worker
    {:ok, hdgSrv} = Supervisor.start_child(sup, worker(HMC5883L.HeadingServer, []))
    #start compass supervisor
    Supervisor.start_child(sup, supervisor(HMC5883L.CompassSupervisor, [hdgSrv]))
  end

  def init(_) do
    supervise [], strategy: :one_for_one
  end
end
