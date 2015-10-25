defmodule MockI2c do
  def write(_pid, _data), do: :ok
  def write_read(_pid, _data, length) do
      bs_length = 8 * length
     <<00 :: size(bs_length)>>
   end
end
