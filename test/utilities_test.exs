defmodule HMC5883L.Utilities_Tests do
  use ExUnit.Case
  
  test "get sampling avg 1", do: assert HMC5883L.Utilities.get_samplingavg(1) == 0x00
  test "get sampling avg 2", do: assert HMC5883L.Utilities.get_samplingavg(2) == 0x01
  test "get sampling avg 4", do: assert HMC5883L.Utilities.get_samplingavg(4) == 0x02
  test "get sampling avg 8", do: assert HMC5883L.Utilities.get_samplingavg(8) == 0x03

  test "get gain value - 0.88", do: assert HMC5883L.Utilities.get_gainvalue(0.88) == 0x00
  test "get gain value - 1370", do: assert HMC5883L.Utilities.get_gainvalue(1370) == 0x00
  test "get gain value - 1.3", do: assert HMC5883L.Utilities.get_gainvalue(1.3) == 0x01
  test "get gain value - 1090", do: assert HMC5883L.Utilities.get_gainvalue(1090) == 0x01 
  test "get gain value - 1.9", do: assert HMC5883L.Utilities.get_gainvalue(1.9) == 0x02
  test "get gain value - 820", do: assert HMC5883L.Utilities.get_gainvalue(820) == 0x02
  test "get gain value - 2.5", do: assert HMC5883L.Utilities.get_gainvalue(2.5) == 0x03
  test "get gain value - 660", do: assert HMC5883L.Utilities.get_gainvalue(660) == 0x03 
  test "get gain value - 4.0", do: assert HMC5883L.Utilities.get_gainvalue(4.0) == 0x04
  test "get gain value - 440", do: assert HMC5883L.Utilities.get_gainvalue(440) == 0x04
  test "get gain value - 4.7", do: assert HMC5883L.Utilities.get_gainvalue(4.7) == 0x05
  test "get gain value - 390", do: assert HMC5883L.Utilities.get_gainvalue(390) == 0x05 
  test "get gain value - 5.6", do: assert HMC5883L.Utilities.get_gainvalue(5.6) == 0x06
  test "get gain value - 330", do: assert HMC5883L.Utilities.get_gainvalue(330) == 0x06
  test "get gain value - 8.1", do: assert HMC5883L.Utilities.get_gainvalue(8.1) == 0x07
  test "get gain value - 230", do: assert HMC5883L.Utilities.get_gainvalue(230) == 0x07 
    
  test "get mode - cont", do: assert HMC5883L.Utilities.get_mode(:continuous) == 0x00
  test "get mode - single", do: assert HMC5883L.Utilities.get_mode(:single) == 0x01
  test "get mode - idle", do: assert HMC5883L.Utilities.get_mode(:idle) == 0x02

  test "get bias - normal", do: assert HMC5883L.Utilities.get_bias(:normal) == 0x00
  test "get bias - positive", do: assert HMC5883L.Utilities.get_bias(:positive) == 0x01
  test "get bias - negative", do: assert HMC5883L.Utilities.get_bias(:negative) == 0x02
  
  test "get data rate - 0.75 Hz", do: assert HMC5883L.Utilities.get_datarate(0.75) == 0x00
  test "get data rate - 1.5 Hz", do: assert HMC5883L.Utilities.get_datarate(1.5) == 0x01
  test "get data rate - 3 Hz", do: assert HMC5883L.Utilities.get_datarate(3) == 0x02
  test "get data rate - 7.5 Hz", do: assert HMC5883L.Utilities.get_datarate(7.5) == 0x03
  test "get data rate - 15 Hz", do: assert HMC5883L.Utilities.get_datarate(15) == 0x04
  test "get data rate - 30 Hz", do: assert HMC5883L.Utilities.get_datarate(30) == 0x05
  test "get data rate - 75 Hz", do: assert HMC5883L.Utilities.get_datarate(75) == 0x06
  test "get data rate - 3.0 Hz", do: assert HMC5883L.Utilities.get_datarate(3.0) == 0x02
  test "get data rate - 15.0 Hz", do: assert HMC5883L.Utilities.get_datarate(15.0) == 0x04
  test "get data rate - 30.0 Hz", do: assert HMC5883L.Utilities.get_datarate(30.0) == 0x05
  test "get data rate - 75.0 Hz", do: assert HMC5883L.Utilities.get_datarate(75.0) == 0x06
end
