HMC5883L
========
[![Build Status](https://travis-ci.org/TattdCodeMonkey/hmc5883l.png?branch=master)](https://travis-ci.org/TattdCodeMonkey/hmc5883l)

This is a module for reading the HMC5883L magnetic compass. It utilizes elixir_ale for configuring and reading the compass over i2c.

**** Work in progress ****

Currently being developed on a Raspberry Pi running raspbian, will be tested on Beagle Bone Black as well

Current design is 

	Supervisor
	    |
	   / \
	  /    \
	Heading Server 
    		   \
		        Compass Supervisor
    		    |
		        Server 


- **HMC5883L.Supervisor:** Starts and supervises heading server and compass supervisor
- **HMC5883L.CompassSupervisor:** Starts and supervises HMC5883L.Server
- **HMC5883L.Server:** 
	- Interacts with compass. 
	- Reads heading @ 5hz. (set with @read_interval) 
	- Sends updates to HMC5883L.HeadingServer
- **HMC5883L.HeadingServer:**
	- get_value(pid) - returns the most recent magnetic heading reading in decimal degrees	 	
	- get_state(pid)
		1. :unknown 	 - initial setting
		2. :initialized  - HMC5883L.Server has been initialized
		3. :calibrated	- HMC5883L.Server has been *Not implemented*
		4. :error		- Set when HMC5883L.Server process terminates
	
####TODO:
- Add additional unit tests
- Load config from env variables
- Handle updating configuration at runtime, changing mode gain etc.
- Implement calibration
