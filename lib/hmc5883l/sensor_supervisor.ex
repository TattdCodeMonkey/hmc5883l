defmodule HMC5883L.SensorSupervisor do
  use Supervisor	

  def start_link(sensor) do
  	id = String.to_atom("hmc5883l_" <> sensor.name <> "_sup")

  	Supervisor.start_link(__MODULE__, [sensor: sensor, name: id], [id: id])
  end

  def init(opts) do
  	sensor = Keyword.get(opts, :sensor)
  	name = Keyword.get(opts, :name)

  	sensor
  	|> children
  	|> supervise([strategy: :one_for_one, name: name])
  end

  defp children(sensor) do
  	state_name = String.to_atom("hmc5883l_" <> sensor.name <> "_state")
  	driver_name = String.to_atom("hmc5883l_" <> sensor.name <> "_driver")
  	evtmgr_name = String.to_atom("hmc5883l_" <> sensor.name <> "_evtmgr")
  	evthan_name = String.to_atom("hmc5883l_" <> sensor.name <> "_evthan")
  	bus_name = get_bus_name(sensor.name)

  	[
  	  Supervisor.Spec.worker(
  	    HMC5883L.Sensor, [
  	      %{
  	      	sensor: sensor,
  	      	config: sensor.config,
  	      	state_name: state_name,
  	      	i2c_name: bus_name,
  	      	event_mgr: evtmgr_name,
  	      },
  	      [name: driver_name]
  	    ],	
  	    [id: driver_name]
  	  ),
  	  Supervisor.Spec.worker(GenEvent, [[name: evtmgr_name]], [id: evtmgr_name]),
  	  Supervisor.Spec.worker(
  	  	MonHandler,
  	  	[
  	  		MonHandler.get_config(
  	  		  evtmgr_name, 
  	  		  HMC5883L.EventHandler, 
  	  		  %{evtmgr_name: evtmgr_name, state_name: state_name}
  	  		), 
  	  		[name: evthan_name]],
  	  	[id: evthan_name]
  	  ),
  	] ++ bus_modules(sensor, bus_name)
  end

  defp get_bus_name(name) do
  	case Code.ensure_loaded?(I2c) do
  		true -> String.to_atom("hmc5883l_" <> name <> "_bus")
  		_ -> nil
  	end
  end

  defp bus_modules(_sensor, nil), do: []
  defp bus_modules(sensor, name) do
  	[
  		Supervisor.Spec.worker(
          I2c,
          [sensor.i2c, 0x1E, [name: name]],
          [id: name]
        )
  	]
  end
end