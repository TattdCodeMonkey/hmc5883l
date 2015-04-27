HMC5883L
========
[![Build Status](https://travis-ci.org/TattdCodeMonkey/hmc5883l.png?branch=master)](https://travis-ci.org/TattdCodeMonkey/hmc5883l)

This is an OTP application for reading the HMC5883L magnetic compass. It utilizes elixir_ale for configuring and reading the compass over i2c.

**** Work in progress ****

Currently being developed on a Raspberry Pi running raspbian, will be tested on Beagle Bone Black as well
- **HMC5883L:** OTP Application, supervises HMC5883L.State & HMC5883L.Supervisor. Also exposes public API
	- start/2: starts application
	- heading/0
	- available?/0
	- gain/0

- **HMC5883L.EventManager:**
	- {:raw_reading, {x,y,z}} - raised with raw x, y, z axis reading from i2c bus
	- {:scaled_reading, {x,y,z}} - raised with scaled x, y, z axis reading from i2c bus. scale is based on current gain setting
	- {:heading, decoded_heading} - raised when heading is decoded from a scaled reading
	- {:available, boolean_availibity} - raised with true when HMC5883L.Driver is successfully initialized, raised with false when HMC5883L.Driver terminates

####TODO:
- read config from compass and check it against local config, before writing config at startup. This could save unnecessary writes during startup in the case of a crash.
- Implement changing gain setting while running
- Add more unit tests / improve coverage
- Maybe add a public event manager that only raises available and heading, this would reduce noise when using with GenEvent.Stream
