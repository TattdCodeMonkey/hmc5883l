use Mix.Config

config :hmc5883l,
  compass: [
    {:gain, 1.3},
    {:mode, :continuous},
    {:bias, :normal},
    {:data_rate, 15},
    {:averaging, 8} 
  ]
