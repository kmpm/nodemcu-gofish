do

    NMEAPROTO = Proto("NMEA0183", "NMEA 0183 Protocol")
	--local bitw = require("bit")
	local f = NMEAPROTO.fields
	
	f.message = ProtoField.string("nmea.message", "Message")
	
	-- The dissector
	function NMEAPROTO.dissector(buffer, pinfo, tree)
		pinfo.cols.protocol = "NMEA0183"
		local subtree = tree:add(NMEAPROTO, buffer())
		subtree:add(f.message, buffer())
		
	end
	
	-- Register the dissector
	udp_table = DissectorTable.get("udp.port")
	udp_table:add(2000, NMEAPROTO)
end
