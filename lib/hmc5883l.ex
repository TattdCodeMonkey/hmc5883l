defmodule HMC5883L do
  alias HMC5883L.Supervisor
  
  def run() do 
    Supervisor.start_link()
    hsPid = Process.whereis :HMC5883L.HeadingServer
    {:ok, hsPid}
  end
end

