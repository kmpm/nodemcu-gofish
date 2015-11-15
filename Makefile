



.PHONY: all init httpd nmea connect other debug files


all: init lib services files
	

init:
	cd src && nodemcu-uploader upload init.lua

lib:
	cd src && nodemcu-uploader upload --compile lib/*.lua

services: 
	cd src && nodemcu-uploader upload --compile services/*.lua 

files:
	nodemcu-uploader upload files/*


connect:
	screen /dev/ttyUSB0 9600

debug:
	screen /dev/ttyUSB0 4800

clean:
	nodemcu-uploader file format

showfiles:
	nodemcu-uploader file list
