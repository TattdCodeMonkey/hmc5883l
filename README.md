HMC5883L
========
[![Build Status](https://travis-ci.org/TattdCodeMonkey/hmc5883l.png?branch=master)](https://travis-ci.org/TattdCodeMonkey/hmc5883l)

This is a module for reading the HMC5883L magnetic compass. It utilizes elixir_ale for configuring and reading the compass over i2c.

**** Work in progress ****

Currently being developed on a Raspberry Pi running raspbian, will be tested on Beagle Bone Black as well
- **HMC5883L:** OTP Application, supervises HMC5883L.State & HMC5883L.Supervisor. Also exposes public API
	- start/2: starts application
	- heading/0
	- calibrated?/0
	- available?/0
	- gain/0
- **HMC5883L.Supervisor:** Starts and supervises EventHandler and compass supervisor
- **HMC5883L.CompassSupervisor:** Starts and supervises elixir_ale I2c process and HMC5883L.Driver
- **HMC5883L.Server:**
	- Interacts with compass.
	- Reads heading @ 5hz. (set with @read_interval)
	- Raises event through HMC5883L.EventManager
- **HMC5883L.State:**
	- get/0: returns entire state object
	- heading/0: returns the last decoded magnetic heading in decimal degrees
	- calibrated?/0: returns if the compass has been locally calibrated for compensation offsets
	- config/0: returns HMC5883L.CompassConfiguration object with current settings
	- gain/0: returns the currently configured gain setting
- **HMC5883L.EventHandler:** Handles events from driver to update HMC5883L.State
- **HMC5883L.EventManager:**
	- {:raw_reading, {x,y,z}} - TODO
	- {:scaled_reading, {x,y,z}} - TODO
	- {:calibrated, {x_offset, y_offset, z_offset}} - TODO
	- {:heading, decoded_heading} - raised when heading is decoded from a raw reading
	- {:available, boolean_availibity} - raised with true when HMC5883L.Driver is successfully initialized, raised with false when HMC5883L.Driver terminates

####TODO:
- Implement calibration
