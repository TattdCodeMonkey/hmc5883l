defmodule HMC5883L.Utilities_Tests do
  use ExUnit.Case
  
  test "encode sampling avg 1", do: assert HMC5883L.Utilities.enc_samplingavg(1) == 0x00
  test "encode sampling avg 2", do: assert HMC5883L.Utilities.enc_samplingavg(2) == 0x01
  test "encode sampling avg 4", do: assert HMC5883L.Utilities.enc_samplingavg(4) == 0x02
  test "encode sampling avg 8", do: assert HMC5883L.Utilities.enc_samplingavg(8) == 0x03

  test "encode gain value - 0.88", do: assert HMC5883L.Utilities.enc_gain(0.88) == 0x00
  test "encode gain value - 1370", do: assert HMC5883L.Utilities.enc_gain(1370) == 0x00
  test "encode gain value - 1.3", do: assert HMC5883L.Utilities.enc_gain(1.3) == 0x01
  test "encode gain value - 1090", do: assert HMC5883L.Utilities.enc_gain(1090) == 0x01 
  test "encode gain value - 1.9", do: assert HMC5883L.Utilities.enc_gain(1.9) == 0x02
  test "encode gain value - 820", do: assert HMC5883L.Utilities.enc_gain(820) == 0x02
  test "encode gain value - 2.5", do: assert HMC5883L.Utilities.enc_gain(2.5) == 0x03
  test "encode gain value - 660", do: assert HMC5883L.Utilities.enc_gain(660) == 0x03 
  test "encode gain value - 4.0", do: assert HMC5883L.Utilities.enc_gain(4.0) == 0x04
  test "encode gain value - 440", do: assert HMC5883L.Utilities.enc_gain(440) == 0x04
  test "encode gain value - 4.7", do: assert HMC5883L.Utilities.enc_gain(4.7) == 0x05
  test "encode gain value - 390", do: assert HMC5883L.Utilities.enc_gain(390) == 0x05 
  test "encode gain value - 5.6", do: assert HMC5883L.Utilities.enc_gain(5.6) == 0x06
  test "encode gain value - 330", do: assert HMC5883L.Utilities.enc_gain(330) == 0x06
  test "encode gain value - 8.1", do: assert HMC5883L.Utilities.enc_gain(8.1) == 0x07
  test "encode gain value - 230", do: assert HMC5883L.Utilities.enc_gain(230) == 0x07 
    
  test "encode mode - cont", do: assert HMC5883L.Utilities.enc_mode(:continuous) == 0x00
  test "encode mode - single", do: assert HMC5883L.Utilities.enc_mode(:single) == 0x01
  test "encode mode - idle", do: assert HMC5883L.Utilities.enc_mode(:idle) == 0x02

  test "encode bias - normal", do: assert HMC5883L.Utilities.enc_bias(:normal) == 0x00
  test "encode bias - positive", do: assert HMC5883L.Utilities.enc_bias(:positive) == 0x01
  test "encode bias - negative", do: assert HMC5883L.Utilities.enc_bias(:negative) == 0x02
  
  test "encode data rate - 0.75 Hz", do: assert HMC5883L.Utilities.enc_datarate(0.75) == 0x00
  test "encode data rate - 1.5 Hz", do: assert HMC5883L.Utilities.enc_datarate(1.5) == 0x01
  test "encode data rate - 3 Hz", do: assert HMC5883L.Utilities.enc_datarate(3) == 0x02
  test "encode data rate - 7.5 Hz", do: assert HMC5883L.Utilities.enc_datarate(7.5) == 0x03
  test "encode data rate - 15 Hz", do: assert HMC5883L.Utilities.enc_datarate(15) == 0x04
  test "encode data rate - 30 Hz", do: assert HMC5883L.Utilities.enc_datarate(30) == 0x05
  test "encode data rate - 75 Hz", do: assert HMC5883L.Utilities.enc_datarate(75) == 0x06
  test "encode data rate - 3.0 Hz", do: assert HMC5883L.Utilities.enc_datarate(3.0) == 0x02
  test "encode data rate - 15.0 Hz", do: assert HMC5883L.Utilities.enc_datarate(15.0) == 0x04
  test "encode data rate - 30.0 Hz", do: assert HMC5883L.Utilities.enc_datarate(30.0) == 0x05
  test "encode data rate - 75.0 Hz", do: assert HMC5883L.Utilities.enc_datarate(75.0) == 0x06
end
