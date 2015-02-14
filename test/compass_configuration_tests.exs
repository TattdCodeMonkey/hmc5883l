defmodule HMC5883L.CompassConfiguration_Tests do
  use ExUnit.Case
  alias HMC5883L.CompassConfiguration

  test "empty array, loads default compass config" do
    :application.set_env(:hmc5883l, :compass, [])
    assert CompassConfiguration.load_from_env() == (CompassConfiguration.new |> CompassConfiguration.set_scale)    
  end
 
  test "compass configuration is loaded - gain and scale set" do
    :application.set_env(:hmc5883l, :compass, [gain: 230])

    appCfg = CompassConfiguration.load_compass_config(CompassConfiguration.new)

    assert appCfg.gain == 230
    assert appCfg.scale == 4.35 
  end

end
