

## Wireshark NMEA
Made a VERY simple dissector in dumps/nmea.lua

tshark -r second.pcapng -T fields -X lua_script:nmea0183.lua -e nmea.message >second.nmea


## refs

* http://www.catb.org/gpsd/NMEA.html#_dbk_depth_below_keel
* http://www.sailoog.com/en/openplotter
* http://www.oceandatarat.org/?page_id=723
* http://opencpn.org/ocpn/nmea_sentences
* http://stripydog.blogspot.se/2015/03/nmea-0183-over-ip-unwritten-rules-for.html
* http://freenmea.net/
* http://www.lowrance.com/Global/Lowrance/Documents/GoFree%20Tier%201%20Networking%20Specification.pdf

* https://github.com/tkurki/navgauge