defmodule HMC5883L.Configuration_Tests do
  use ExUnit.Case
  alias HMC5883L.Configuration

  test "empty array, loads default config" do
    values = []
    assert Configuration.load_config_from_array(values) == Configuration.new    
  end

  test "compass configuration is loaded" do
    compass_values = [
      gain: 230
    ]

    appCfg = Configuration.load_config_from_array(compass_values)
    |> Configuration.set_scale

    assert appCfg.gain == 230
    assert appCfg.scale == 4.35 
  end

end
