HMC5883L
========
[![Build Status](https://travis-ci.org/TattdCodeMonkey/hmc5883l.png?branch=master)](https://travis-ci.org/TattdCodeMonkey/hmc5883l)

This is an OTP application for reading the HMC5883L magnetic compass. It utilizes elixir_ale for configuring and reading the compass over i2c bus.

- **HMC5883L:** OTP Application, supervises HMC5883L.State & HMC5883L.Supervisor. Also exposes public API
	- start/2: starts application

- **Event Manager:**
	- {:raw_reading, {x,y,z}} - raised with raw x, y, z axis reading from i2c bus
	- {:scaled_reading, {x,y,z}} - raised with scaled x, y, z axis reading from i2c bus. scale is based on current gain setting
	- {:heading, decoded_heading} - raised when heading is decoded from a scaled reading
	- {:available, boolean_availibity} - raised with true when HMC5883L.Driver is successfully initialized, raised with false when HMC5883L.Driver terminates

  Event manager is registered with a named based on the configured sensor name, following the template `:hmc5883l_[name]_evtmgr`.

## Configuration

```elixir
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
```

`name`   : used to identify the sensor and name processes
`i2c`    : name of the i2c bus to connect to the sensor on
`config` : compass configuration values. See HMC5883L.CompassConfiguration for more information

## Installation
Available in Hex, the package can be installed as:

  1. Add hmc5883l to your list of dependencies in `mix.exs`:

        def deps do
          [{:hmc5883l, "~> 0.5.0"}]
        end

  2. Ensure hmc5883l is started before your application:

        def application do
          [applications: [:hmc5883l]]
        end
