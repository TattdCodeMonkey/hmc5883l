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

  @spec decode_config(<<_::24>>) :: %{}
  def decode_config(<<cfga,cfgb,modeReg>>) do
    regA    = <<cfga>>    |> decode_cfga
    regB    = <<cfgb>>    |> decode_cfgb
    regMode = <<modeReg>> |> decode_modereg
    regA |> Map.merge regB |> Map.merge regMode
  end

  @spec encode_config(%{}) :: <<_::24>>
  def encode_config(config) do
    cfga = config |> encode_cfga
    cfgb = config |> encode_cfgb
    modereg = config |> encode_modereg

    cfga <> cfgb <> modereg
  end

  #########
  ###  Config Register A
  ##########
  @spec default_cfga() :: <<_::8>>
  def default_cfga(), do: encode_cfga(8,15,:normal)
  @spec encode_cfga(%{}) :: <<_::8>>
  def encode_cfga(%{averaging: avg, data_rate: rate, bias: bias}), do: encode_cfga(avg, rate, bias)
  @spec encode_cfga(number, number, atom) :: <<_::8>>
  def encode_cfga(avg, rate, bias) do
    bsAvg   = <<enc_samplingavg(avg)::size(@avg_bit_len)>>
    bsDR    = <<enc_datarate(rate)::size(@drate_bit_len)>>
    bsBias  = <<enc_bias(bias)::size(@bias_bit_len)>>
    bsSpare = <<0::size(@cfga_spare_bit_len)>>
    <<bsSpare::bitstring, bsAvg::bitstring, bsDR::bitstring, bsBias::bitstring>>
  end

  @spec decode_cfga(<<_::8>>) :: %{}
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
  @spec default_cfgb() :: <<_::8>>
  def default_cfgb(), do: encode_cfgb(1.3)

  @spec encode_cfgb(%{}) :: <<_::8>>
  def encode_cfgb(%{gain: gain}), do: encode_cfgb(gain)
  
  @spec encode_cfgb(number) :: <<_::8>>
  def encode_cfgb(gain) do
    bsGain  = <<enc_gain(gain)::size(@gain_bit_len)>>
    bsSpare = <<0::size(@cfgb_spare_bit_len)>>
    <<bsGain::bitstring, bsSpare::bitstring>>
  end

  @spec decode_cfgb(<<_::8>>) :: %{}
  def decode_cfgb(cfgb) do
    <<bsGain::size(@gain_bit_len), _::size(@cfgb_spare_bit_len)>> = cfgb
    %{gain: dec_gain(bsGain)}
  end

  #########
  ###  Mode Register
  ##########
  @spec default_modereg() :: <<_::8>>
  def default_modereg(), do: encode_modereg(:continuous)
  
  @spec encode_modereg(%{}) :: <<_::8>>
  def encode_modereg(%{mode: mode}), do: encode_modereg(mode)
  
  @spec encode_modereg(atom) :: <<_::8>>
  def encode_modereg(mode) do
    bsHighSpeedI2c = <<0::size(@high_spd_i2c)>> #always zero for now
    bsMode  = <<enc_mode(mode)::size(@mode_bit_len)>>
    bsSpare = <<0::size(@mdrg_spare_bit_len)>>
    <<bsHighSpeedI2c::bitstring, bsSpare::bitstring, bsMode::bitstring>>
  end

  @spec decode_modereg(<<_::8>>) :: %{}
  def decode_modereg(modeReg) do
    <<_::size(@high_spd_i2c), _::size(@mdrg_spare_bit_len), bsMode::size(@mode_bit_len)>> = modeReg
    %{mode: dec_mode(bsMode)}
  end

  #########
  ###  Heading decode
  ##########
  @doc """
  Takes the 6 byte heading reading from compass and decodes to a decimal degrees angle using the current gain scale value.
  """
  @spec decode_heading(<<_ :: 48>>, float) :: float
  def decode_heading(<<x_raw :: size(16)-signed, _z_raw :: size(16)-signed, y_raw :: size(16)-signed>>, scale) do
    x_out = x_raw * scale
    y_out = y_raw * scale
#   z_out = z_raw * scale

    :math.atan2(y_out,x_out)
    |> bearing_to_degrees
  end

  defp bearing_to_degrees(rad_ber) when rad_ber < 0 do
    rad_ber + @one_radian 
    |> bearing_to_degrees
  end
  defp bearing_to_degrees(rad_ber) when rad_ber > @one_radian do
    rad_ber - @one_radian 
    |> bearing_to_degrees
  end
   defp bearing_to_degrees(rad_ber) do
    rad_ber * @rad_to_degrees 
  end
end
