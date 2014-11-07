HMC5883L
========

This is a module for reading the HMC5883L magnetic compass. It utilizes elixir_ale for configuring and reading the compass over i2c.

**** Work in progress ****

Currently being developed on a Raspberry Pi running raspbian, will be tested on Beagle Bone Black as well

Current design is 

	Supervisor
	    |
	   / \
	  /    \
	Heading Server (holds latest valid heading read)
		   \
		    Compass Supervisor
		    |
		    Compass Server (Handle all interaction with compass over i2c)
