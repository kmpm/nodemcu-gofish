nodemcu-gofish
==============
NMEA 0183 (serial) to wifi bridge using esp8266 flashed with nodemcu.

This is to make a cheap, simple and fun solution for connecting 
my Plotter/Sounder to my Android phone. 
This is simply done by setting up the ESP8266 as a Soft AP with DHCP and 
taking the RS-232 NMEA output from something that can produce NMEA sentences
and broadcasting them over UDP on port 2000 to anything connected via Wifi on
the ESP8266.

This means that several "clients" at the same time can listen in on the NMEA
traffic. For example an Android phone and a computer running kplex

## Hardware
Basically a ESP-01 (or better) module connected to a MAX3232 breakout bord from Sparkfun
all driven from a 12V battery using a DC/DC to 3.3v converter from pololu.

This is currently only tested by connecting to a Lowrance Elite 4 CHIRP.

## Install
* Flash the device with nodemcu __./esptool.py write_flash 0x00000 nodemcu_integer_0.9.6-dev_20150704.bin__
* Restart it
* Install the scripts and files using __make all__

## references
* NMEA - http://www.catb.org/gpsd/NMEA.html
* Kplex - http://www.stripydog.com/kplex/
* NMEA over IP - http://stripydog.blogspot.se/2015/03/nmea-0183-over-ip-unwritten-rules-for.html
* NMEA Dissector for Wireshark - https://github.com/kmpm/wireshark-nmea
