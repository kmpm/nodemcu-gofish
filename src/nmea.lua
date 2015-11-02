last_msg = ""

local t = {
"$GPGLL,6XX5.2070,N,02XX2.4710,E,000050,V*39",
"$GPRMB,V,5.69,L,,,6439.8241,N,02059.1129,E,6.09,15 2.2,0.0,V*12",
"$GPBWC,000050,6XX9.8241,N,02XX9.1129,E,152.2,T,,M, 6.09,N,***X,N*15",
"$GPRMC,000050,V,6XX5.2XX0,N,02052.4710,E,0.0,0.0,0 10200,5.4,E*67",
"$GPGGA,000050,6XX5.2XX0,N,02XX2.4710,E,0,0,99.00,5 ,M,,,,*3F",
"$GPGSA,A,1,,,,,,,,,,,,,,99.00,99.00,0.00*2C",
"$GPGSV,4,1,13,3,6,281,,5,28,45,,6,26,272,,7,6,357, *4B",
"$GPGSV,4,2,13,13,10,325,,16,49,287,,18,7,160,,21,5 7,185,*49",
"$GPGSV,4,3,13,26,,71,,27,15,273,,29,39,106,,31,3,2 18,*75",
"$GPGSV,4,4,13,138,,0,*71",
"$SDVLW,0.7,N,0.7,N*5A",
"$SDVHW,,T,,M,,N,,K*42",
"$SDMTW,20.1,C*07",
"$SDDPT,034.25,f,010.44,M,005.64,F*27",
"$SDDBT,,,,,,*45",
"$GPAPB,V,A,5.69,L,N,V,V,221.7,T,***X,152.2,T,266.7 ,T,V*24"
}

--$IIDBT,034.25,f,010.44,M,005.64,F*27
local bc = wifi.ap.getbroadcast()
--bc = "255.255.255.255"
local index = 1
uc = net.createConnection(net.UDP)
uc:connect(2000, bc)

-- uart.setup(0,4800,8,0,1,0)
-- uart.on("data", "\n", nmea_in)


function nmea_in(data)
	last_msg = data
	nmea_out(data)
end


function nmea_out(data)
	uc:send(data)
end

tmr.alarm(2, 1000, 1, function ()
	nmea_in(t[index] .. "\r\n")
	index = index + 1
	if index >= 16 then
		index = 1
	end
end)