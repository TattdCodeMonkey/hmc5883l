defmodule HMC5883L.Utilities do
  import MultiDef

  mdef get_samplingavg do
    1 -> 0x00
    2 -> 0x01
    4 -> 0x02
    8 -> 0x03
  end  

  mdef get_gainvalue do
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

  mdef get_mode do
    :continuous -> 0x00
    :single -> 0x01
    :idle -> 0x02
  end

  mdef get_bias do
    :normal -> 0x00
    :positive -> 0x01
    :negative -> 0x02
  end

  mdef get_datarate do
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
end
