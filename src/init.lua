majorVer, minorVer, devVer, chipid, flashid, flashsize, flashmode, flashspeed = node.info();

print("Flash size:"..flashsize.." kBytes.")
print('Chip ID:' .. chipid)


dofile('lib/net-ap.lc')



print('')

last_msg = ""

function startup()
	uart.on("data")
	if abort == true then
		print('startup aborted')
		return
	end
	print('starting...')
	dofile("services/httpd.lc")
	dofile('services/dns-liar.lc')
	dofile("services/nmea.lc")
end

abort = false
print('Press x now to abort startup.')
uart.on("data", 1, function(data)
	print("receive from uart:", data)
	if data=="x" then
		abort = true
		uart.on("data")
		tmr.stop(1)
		startup()
	end
end, 0)
print("Init done Free Heap:", node.heap())
print ('Will startup services in 3 seconds...')
tmr.alarm(1,3000,0,startup)
