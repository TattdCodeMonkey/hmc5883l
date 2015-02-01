use Mix.Config

board = :pi

config :hmc5883l, board: board

import_config "config.compass.exs"
import_config "config.#{board}.exs"
