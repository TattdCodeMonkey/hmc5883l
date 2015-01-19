defmodule HMC5883L.InterfaceControl do
  import HMC5883L.Utilities

  @one_radian 6.283185307179586
  @rad_to_degrees 57.29577951308232

  @avg_bit_len    2
  @drate_bit_len  3
  @bias_bit_len   2
  @gain_bit_len   3
  @mode_bit_len   2
  @high_spd_i2c   1

  @cfga_spare_bit_len 1
  @cfgb_spare_bit_len 5
  @mdrg_spare_bit_len 5

  def decode_config(<<cfga,cfgb,modeReg>>) do
    regA    = <<cfga>>    |> decode_cfga
    regB    = <<cfgb>>    |> decode_cfgb
    regMode = <<modeReg>> |> decode_modereg
    regA |> Map.merge regB |> Map.merge regMode
  end

  def encode_config(config) do
    cfga = config |> encode_cfga
    cfgb = config |> encode_cfgb
    modereg = config |> encode_modereg

    cfga <> cfgb <> modereg
  end

  #########
  ###  Config Register A
  ##########
  def default_cfga(), do: encode_cfga(8,15,:normal)
  def encode_cfga(%{averaging: avg, data_rate: rate, bias: bias}), do: encode_cfga(avg, rate, bias)
  def encode_cfga(avg, rate, bias) do
    bsAvg   = <<enc_samplingavg(avg)::size(@avg_bit_len)>>
    bsDR    = <<enc_datarate(rate)::size(@drate_bit_len)>>
    bsBias  = <<enc_bias(bias)::size(@bias_bit_len)>>
    bsSpare = <<0::size(@cfga_spare_bit_len)>>
    <<bsSpare::bitstring, bsAvg::bitstring, bsDR::bitstring, bsBias::bitstring>>
  end

  def decode_cfga(cfga) do
    <<_::size(@cfga_spare_bit_len), bsAvg::size(@avg_bit_len), bsDataRate::size(@drate_bit_len), bsBias::size(@bias_bit_len)>> = cfga
    averaging = dec_samplingavg(bsAvg)
    dataRate  = dec_datarate(bsDataRate)
    bias      = dec_bias(bsBias)

    %{averaging: averaging, data_rate: dataRate, bias: bias}
  end
  #########
  ###  Config Register B
  ##########
  def default_cfgb(), do: encode_cfgb(1.3)
  def encode_cfgb(%{gain: gain}), do: encode_cfgb(gain)
  def encode_cfgb(gain) do
    bsGain  = <<enc_gain(gain)::size(@gain_bit_len)>>
    bsSpare = <<0::size(@cfgb_spare_bit_len)>>
    <<bsGain::bitstring, bsSpare::bitstring>>
  end

  def decode_cfgb(cfgb) do
    <<bsGain::size(@gain_bit_len), bsSpare::size(@cfgb_spare_bit_len)>> = cfgb
    %{gain: dec_gain(bsGain)}
  end

  #########
  ###  Mode Register
  ##########
  def default_modereg(), do: encode_modereg(:continuous)
  def encode_modereg(%{mode: mode}), do: encode_modereg(mode)
  def encode_modereg(mode) do
    bsHighSpeedI2c = <<0::size(@high_spd_i2c)>> #always zero for now
    bsMode  = <<enc_mode(mode)::size(@mode_bit_len)>>
    bsSpare = <<0::size(@mdrg_spare_bit_len)>>
    <<bsHighSpeedI2c::bitstring, bsSpare::bitstring, bsMode::bitstring>>
  end

  def decode_modereg(modeReg) do
    <<_::size(@high_spd_i2c), _::size(@mdrg_spare_bit_len), bsMode::size(@mode_bit_len)>> = modeReg
    %{mode: dec_mode(bsMode)}
  end

  #########
  ###  Heading decode
  ##########
  def decodeHeading(<<x_raw :: size(16)-signed, z_raw :: size(16)-signed, y_raw :: size(16)-signed>>, gain) do
    x_out = x_raw * gain
    y_out = y_raw * gain
    z_out = z_raw * gain

    :math.atan2(y_out,x_out)
    |> bearingToDegrees
  end

  defp bearingToDegrees(rad_ber) when rad_ber < 0 do
    rad_ber + @one_radian 
    |> bearingToDegrees
  end
  defp bearingToDegrees(rad_ber) when rad_ber > @one_radian do
    rad_ber - @one_radian 
    |> bearingToDegrees
  end
   defp bearingToDegrees(rad_ber) do
    rad_ber * @rad_to_degrees 
  end
end
