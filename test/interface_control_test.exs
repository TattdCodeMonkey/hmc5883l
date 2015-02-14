defmodule HMC5883L.InterfaceControl_Tests do
  use ExUnit.Case
  use ShouldI, async: true
  alias HMC5883L.InterfaceControl
  alias HMC5883L.CompassConfiguration

  test "eating dogfood" do
    default_config = CompassConfiguration.new()

    encoded_config = InterfaceControl.encode_config(default_config)
    decoded_config = InterfaceControl.decode_config(encoded_config)

    assert default_config.averaging == decoded_config.averaging
    assert default_config.data_rate == decoded_config.data_rate
    assert default_config.bias == decoded_config.bias
    assert default_config.gain == decoded_config.gain
    assert default_config.mode == decoded_config.mode
  end

  test "decode heading" do
    
  end
end  
