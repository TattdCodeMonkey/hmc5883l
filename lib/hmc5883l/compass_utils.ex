defmodule HMC5883L.Utilities do
  import MultiDef

  mdef enc_samplingavg do
    1 -> 0x00
    2 -> 0x01
    4 -> 0x02
    8 -> 0x03
  end  
  
  mdef dec_samplingavg do
    0x00 -> 1
    0x01 -> 2
    0x02 -> 4
    0x03 -> 8
    <<0::size(2)>> -> dec_samplingavg(0)
    <<1::size(2)>> -> dec_samplingavg(1)
    <<2::size(2)>> -> dec_samplingavg(2)
    <<3::size(2)>> -> dec_samplingavg(3)
  end

  mdef enc_gain do
    0.88 -> 0x00
    1.3 -> 0x01
    1.9 -> 0x02
    2.5 -> 0x03
    4.0 -> 0x04
    4.7 -> 0x05
    5.6 -> 0x06
    8.1 -> 0x07
    1370 -> 0x00
    1090 -> 0x01
    820 -> 0x02
    660 -> 0x03
    440 -> 0x04
    390 -> 0x05
    330 -> 0x06
    230 -> 0x07
  end

  mdef dec_gain do
    0x00 -> 0.88
    0x01 -> 1.3
    0x02 -> 1.9
    0x03 -> 2.5
    0x04 -> 4.0
    0x05 -> 4.7
    0x06 -> 5.6
    0x07 -> 8.1
    <<0::size(3)>> -> dec_gain(0) 
    <<1::size(3)>> -> dec_gain(1)
    <<2::size(3)>> -> dec_gain(2)
    <<3::size(3)>> -> dec_gain(3)
    <<4::size(3)>> -> dec_gain(4)
    <<5::size(3)>> -> dec_gain(5)
    <<6::size(3)>> -> dec_gain(6)
    <<7::size(3)>> -> dec_gain(7)
  end

  mdef dec_gain_gause do
    0x00 -> 1370
    0x01 -> 1090
    0x02 -> 820
    0x03 -> 660
    0x04 -> 440
    0x05 -> 390
    0x06 -> 330
    0x07 -> 230
    <<0::size(3)>> -> dec_gain_gause(0x00)
    <<1::size(3)>> -> dec_gain_gause(0x01)
    <<2::size(3)>> -> dec_gain_gause(0x02)
    <<3::size(3)>> -> dec_gain_gause(0x03)
    <<4::size(3)>> -> dec_gain_gause(0x04)
    <<5::size(3)>> -> dec_gain_gause(0x05)
    <<6::size(3)>> -> dec_gain_gause(0x06)
    <<7::size(3)>> -> dec_gain_gause(0x07)
  end

  mdef enc_mode do
    :continuous -> 0x00
    :single -> 0x01
    :idle -> 0x02
  end

  mdef dec_mode do
    0x00 -> :continuous
    0x01 -> :single
    0x02 -> :idle
    <<0::size(2)>> -> dec_mode(0)
    <<1::size(2)>> -> dec_mode(1)
    <<2::size(2)>> -> dec_mode(2)
  end

  mdef enc_bias do
    :normal -> 0x00
    :positive -> 0x01
    :negative -> 0x02
  end

  mdef dec_bias do
    0x00 -> :normal
    0x01 -> :positive
    0x02 -> :negative
    <<0::size(2)>> -> dec_bias(0x00)
    <<1::size(2)>> -> dec_bias(0x01)
    <<2::size(2)>> -> dec_bias(0x02)
  end

  mdef enc_datarate do
    0.75 -> 0x00
    1.5 -> 0x01
    3 -> 0x02
    3.0 -> 0x02
    7.5 -> 0x03
    15 -> 0x04
    15.0 -> 0x04
    30 -> 0x05
    30.0 -> 0x05
    75 -> 0x06
    75.0 -> 0x06
  end

  mdef dec_datarate do
    0x00 -> 0.75
    0x01 -> 1.5
    0x02 -> 3.0
    0x03 -> 7.5
    0x04 -> 15.0
    0x05 -> 30.0
    0x06 -> 75.0
    <<0::size(3)>> -> dec_datarate(0x00)
    <<1::size(3)>> -> dec_datarate(0x01)
    <<2::size(3)>> -> dec_datarate(0x02)
    <<3::size(3)>> -> dec_datarate(0x03)
    <<4::size(3)>> -> dec_datarate(0x04)
    <<5::size(3)>> -> dec_datarate(0x05)
    <<6::size(3)>> -> dec_datarate(0x06)
  end
  
  mdef get_scale do
    0.88 -> 0.73
    1.3 -> 0.92
    1.9 -> 1.22
    2.5 -> 1.52
    4.0 -> 2.27
    4.7 -> 2.56
    5.6 -> 3.03
    8.1 -> 4.35
    1370 -> 0.73
    1090 -> 0.92
    820 -> 1.22
    660 -> 1.52
    440 -> 2.27 
    390 -> 2.56
    330 -> 3.03
    230 -> 4.35
  end
end
