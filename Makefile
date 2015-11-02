



.PHONY: all init servers nmea connect other


all: init nmea servers 
	


init:
	cd src && nodemcu-uploader upload init.lua

other: nmea servers

nmea:
	cd src && nodemcu-uploader upload --compile nmea.lua


servers: 
	cd src && nodemcu-uploader upload --compile servers.lua
	cd files && nodemcu-uploader upload index.htm


connect:
	screen /dev/ttyUSB0 9600
	