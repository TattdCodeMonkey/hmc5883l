defmodule HMC5883L.InterfaceControl do
  import HMC5883L.Utilities

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
  def decode_config(<<cfg_a,cfg_b,mode_reg>>) do
    reg_a    = <<cfg_a>>    |> decode_cfga
    reg_b    = <<cfg_b>>    |> decode_cfgb
    reg_mode = <<mode_reg>> |> decode_modereg
    reg_a |> Map.merge reg_b |> Map.merge reg_mode
  end

  @spec encode_config(%{}) :: <<_::24>>
  def encode_config(config) do
    cfg_a = config |> encode_cfga
    cfg_b = config |> encode_cfgb
    mode_reg = config |> encode_modereg

    cfg_a <> cfg_b <> mode_reg
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
    bs_avg   = <<enc_samplingavg(avg)::size(@avg_bit_len)>>
    bs_dr    = <<enc_datarate(rate)::size(@drate_bit_len)>>
    bs_bias  = <<enc_bias(bias)::size(@bias_bit_len)>>
    bs_spare = <<0::size(@cfga_spare_bit_len)>>
    <<bs_spare::bitstring, bs_avg::bitstring, bs_dr::bitstring, bs_bias::bitstring>>
  end

  @spec decode_cfga(<<_::8>>) :: %{}
  def decode_cfga(cfg_a) do
    <<_::size(@cfga_spare_bit_len), bs_avg::size(@avg_bit_len), bs_data_rate::size(@drate_bit_len), bs_bias::size(@bias_bit_len)>> = cfg_a
    averaging = dec_samplingavg(bs_avg)
    data_rate = dec_datarate(bs_data_rate)
    bias      = dec_bias(bs_bias)

    %{averaging: averaging, data_rate: data_rate, bias: bias}
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
    bs_gain  = <<enc_gain(gain)::size(@gain_bit_len)>>
    bs_spare = <<0::size(@cfgb_spare_bit_len)>>
    <<bs_gain::bitstring, bs_spare::bitstring>>
  end

  @spec decode_cfgb(<<_::8>>) :: %{}
  def decode_cfgb(cfg_b) do
    <<bs_gain::size(@gain_bit_len), _::size(@cfgb_spare_bit_len)>> = cfg_b
    %{gain: dec_gain(bs_gain)}
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
    bs_highspeed_i2c = <<0::size(@high_spd_i2c)>> #always zero for now
    bs_mode  = <<enc_mode(mode)::size(@mode_bit_len)>>
    bs_spare = <<0::size(@mdrg_spare_bit_len)>>
    <<bs_highspeed_i2c::bitstring, bs_spare::bitstring, bs_mode::bitstring>>
  end

  @spec decode_modereg(<<_::8>>) :: %{}
  def decode_modereg(mode_reg) do
    <<_::size(@high_spd_i2c), _::size(@mdrg_spare_bit_len), bs_mode::size(@mode_bit_len)>> = mode_reg
    %{mode: dec_mode(bs_mode)}
  end

  #########
  ###  Heading decode
  ##########
  @doc """
  Takes the 6 byte heading reading from compass and decodes to a decimal degrees angle using the current gain scale value.
  """
  @spec decode_heading(<<_ :: 48>>) :: atom
  def decode_heading(data) do
    <<
      x_raw :: size(16)-signed, 
      z_raw :: size(16)-signed, 
      y_raw :: size(16)-signed
    >> = data
    
    {:raw_reading, {x_raw, y_raw, z_raw}} |> notify
  end
end
