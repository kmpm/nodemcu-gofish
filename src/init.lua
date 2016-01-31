majorVer, minorVer, devVer, chipid, flashid, flashsize, flashmode, flashspeed = node.info();

print('-----------------------')
print("Flash size: "..flashsize.." kBytes.")
print('Chip ID: ' .. chipid)

function log(msg)
    if not quiet then print(msg) end
end

dofile('lib/net-ap.lc')
dofile("services/httpd.lc")
dofile('services/dns-liar.lc')



print('')
quiet = false
last_msg = ""

function startup()
	uart.on("data")
	if abort == true then
		log('startup aborted')
		return
	end
	log('starting...')
    quiet = true
	dofile("services/nmea.lc")
end

abort = false
log('Press x now to abort startup.')
uart.on("data", 1, function(data)
	log("receive from uart:", data)
	if data=="x" then
		abort = true
		uart.on("data")
		tmr.stop(1)
		startup()
	end
end, 0)
log("Init done Free Heap:" .. node.heap())
log('Will startup nmea services in 3 seconds...')
tmr.alarm(1,3000,0,startup)
