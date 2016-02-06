use Mix.Config

config :hmc5883l, sensors: [
	%{
		name: "ch1",
		i2c: "i2c-1",
		config: %{
			gain: 1.3,
  		mode: :continuous,
  		bias: :normal,
  		data_rate: 15,
  		averaging: 8
		}
	}
]
