defmodule HMC5883L.CompassConfiguration_Tests do
  use ExUnit.Case
  alias HMC5883L.CompassConfiguration

  test "empty array, loads default compass config" do
    :application.set_env(:hmc5883l, :compass, [])
    assert CompassConfiguration.load_from_env() == (CompassConfiguration.new |> CompassConfiguration.set_axis_gauss)    
  end

  test "compass configuration is loaded - gain and scale set" do
    :application.set_env(:hmc5883l, :compass, [gain: 8.1])

    appCfg = CompassConfiguration.load_compass_config(CompassConfiguration.new)

    assert appCfg.gain == 8.1
    assert appCfg.gauss == {230, 205}
  end

end
