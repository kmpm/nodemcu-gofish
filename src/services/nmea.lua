

--$IIDBT,034.25,f,010.44,M,005.64,F*27
bc = wifi.ap.getbroadcast()
--bc = "255.255.255.255"

uc = net.createConnection(net.UDP)
uc:connect(2000, bc)

print('setting up nmea, no more console after here')

function nmea_in(data)
	last_msg = data
	--uart.write(0, 'got data' .. data)
	nmea_out(data)
end

function nmea_out(data)
	uc:send(data)
end

uart.setup(0,4800,8,0,1,0)
uart.on("data", "\n", nmea_in, 0)

-- tmr.alarm(1, 5000, 1, function ()
-- 	nmea_in('fake\r')
-- 	end)