defmodule HMC5883L.Configuration_Tests do
  use ExUnit.Case
  use ShouldI, async: true
  alias HMC5883L.Configuration

  test "empty array, loads default config" do
    :application.set_env(:hmc5883l, :compass, [])
    :application.set_env(:hmc5883l, :i2c, [])
    
    assert Configuration.load_from_env() == (Configuration.new |> Configuration.set_scale)    
  end
  
  test "i2c configuration is laoded" do
    :application.set_env(:hmc5883l, :i2c, [i2c_channel: "i2c-2"])
  
    assert Configuration.load_i2c_config(Configuration.new).i2c_channel == "i2c-2"
  end
  
  test "compass configuration is loaded - gain and scale set" do
    :application.set_env(:hmc5883l, :compass, [gain: 230])

    appCfg = Configuration.load_compass_config(Configuration.new)

    assert appCfg.gain == 230
    assert appCfg.scale == 4.35 
  end

 end
