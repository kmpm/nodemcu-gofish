split = function(s, pattern, maxsplit)
  local pattern = pattern or ' '
  local maxsplit = maxsplit or -1
  local s = s
  local t = {}
  local patsz = #pattern
  while maxsplit ~= 0 do
    local curpos = 1
    local found = string.find(s, pattern)
    if found ~= nil then
      table.insert(t, string.sub(s, curpos, found - 1))
      curpos = found + patsz
      s = string.sub(s, curpos)
    else
      table.insert(t, string.sub(s, curpos))
      break
    end
    maxsplit = maxsplit - 1
    if maxsplit == 0 then
      table.insert(t, string.sub(s, curpos - patsz - 1))
    end
  end
  return t
end

function lookup(list, index)
	v = list[index]
	if (v == nil) then
		return index .. '?'
	end
	return v
end


do

    NMEAPROTO = Proto("NMEA0183", "NMEA 0183 Protocol")
	--local bitw = require("bit")
	local f = NMEAPROTO.fields

	f.message = ProtoField.string("nmea.message", "Message")
	f.talker = ProtoField.string('nmea.talker', 'Talker')
	f.msgtype = ProtoField.string('nmea.type', 'Type')
	f.dpt_depth = ProtoField.string('nmea.dpt.depth', 'Depth in Meters')
	f.dpt_offset = ProtoField.string('nmea.dpt.offset', 'Offset from transducer')

	f.gll_latitude = ProtoField.string('nmea.gll.latitude', 'Latitude')
	f.gll_ns = ProtoField.string('nmea.gll.ns', 'North/South')
	f.gll_longitude = ProtoField.string('nmea.gll.longitude', 'Longitude')
	f.gll_ew = ProtoField.string('nmea.gll.ew', 'East/West')

	f.gsv_tot_transmit = ProtoField.string('nmea.gsv.tot_transmit', 'Total transmitted in group')
	f.gsv_tot_view = ProtoField.string('nmea.gsv.tot_view', 'Total satellites in view')


	-- The dissector
	function NMEAPROTO.dissector(buffer, pinfo, tree)
		pinfo.cols.protocol = "NMEA0183"

		local st
		local talkers = {}
		local types = {}
		talkers['GP'] = 'GPS Receiver'
		talkers['SD'] = 'Sounder, Depth'

		types['APB'] = 'Autopilot Sentence "B"'
		types['DBT'] = 'Depth below transducer'
		types['DPT'] = 'Depth of Water'
		types['GGA'] = 'GPS Fix Data'
		types['GSA'] = 'GPS DOP and active satellites'
		types['GSV'] = 'Satellites in view'
		types['GLL'] = 'Geographic Position - Latitude/Longitude'
		types['MTW'] = 'Mean Temperature of Water'
		types['RMB'] = 'Recommended Minimum Navigation Information'
		types['RMC'] = 'Recommended Minimum Navigation Information'
		types['VHW'] = 'Water speed and heading'
		types['VLW'] = 'Distance Traveled through Water'

		local offset = 0
		while buffer(offset, 1):string()~= '$' do
			offset = offset + 1
		end
		local subtree = tree:add(NMEAPROTO, buffer())
		subtree:add(f.message, buffer())

		offset = offset + 1

		local content = buffer(offset):string()

		local fields = split(content, ',')
		local last = #fields

		fields[last] = split(fields[last], '*')[1]

		local tag_subtree = subtree:add("Tag", nil)
		local talker = string.sub(fields[1], 1, 2)
		tag_subtree:append_text(", Talker: " .. lookup(talkers, talker))
		tag_subtree:add(f.talker, talker)

		local msgtype = string.sub(fields[1], 3)
		tag_subtree:append_text(", Type: " .. lookup(types, msgtype))
		tag_subtree:add(f.msgtype, msgtype)

		if (msgtype == 'DPT') then
			st = subtree:add('Depth')
			st:append_text(', ' .. fields[2] .. 'm ' .. fields[3])
			st:add(f.dpt_depth, fields[2])
			st:add(f.dpt_offset, fields[3])
		elseif (msgtype == 'GLL') then
			st = subtree:add("Position")
			st:append_text(', ' .. fields[2] .. fields[3])
			st:add(f.gll_latitude, fields[2])
			st:add(f.gll_ns, fields[3])

			st:append_text(', ' .. fields[4] .. fields[5])
			st:add(f.gll_longitude, fields[4])
			st:add(f.gll_ew, fields[5])
		elseif (msgtype == 'GSV') then
			st = subtree:add("Satellites")
			st:append_text(', ' .. fields[4])
			st:add(f.gsv_tot_transmit, fields[2])
			st:add(f.gsv_tot_view, fields[4])
		end

	end

	-- Register the dissector
	udp_table = DissectorTable.get("udp.port")
	udp_table:add(2000, NMEAPROTO)
end
