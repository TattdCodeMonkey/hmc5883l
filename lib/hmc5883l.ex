defmodule HMC5883L do
  alias HMC5883L.Supervisor
  
  @doc """
    Starts the app supervisor and returns the pid of the HeadingServer. 
    Call HMC5883L.HeadingServer.get_value with the pid to get latest magnetic heading reading in decimal degrees 
  """
  @spec run!() :: { atom, pid }
  def run!() do 
    {:ok,_supPid} = Supervisor.start_link()
    hsPid = Process.whereis :HMC5883L.HeadingServer
    {:ok, hsPid}
  end
end

