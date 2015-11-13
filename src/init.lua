majorVer, minorVer, devVer, chipid, flashid, flashsize, flashmode, flashspeed = node.info();
print("Flash size is "..flashsize.." kBytes.")

wifi.setmode(wifi.SOFTAP)
cfg={}
cfg.ssid="GoFish"
cfg.pwd="supersecret"
wifi.ap.config(cfg)

cfg={}
cfg.ip="169.254.1.1"
cfg.netmask="255.255.255.0"
cfg.gateway="169.254.1.1"
wifi.ap.setip(cfg)

ip, mask = wifi.ap.getip()
print(ip .. '/' .. mask)

dhcp_config = {}
dhcp_config.start = "169.254.1.129"
wifi.ap.dhcp.config(dhcp_config)
wifi.ap.dhcp.start()

last_msg = ""

function startup()
	uart.on("data")
	if abort == true then
		print('startup aborted')
		return
	end
	print('starting...')
	dofile("servers.lc")
	dofile("nmea.lc")
end

abort = false
print('Send some xxxx Keystrokes now to abort startup.')
uart.on("data", 1, function(data)
	print("receive from uart:", data)
	if data=="x" then
		abort = true
		uart.on("data")
		tmr.stop(1)
		startup()
	end
end, 0)

print ('Will launch services in 3 seconds...')
tmr.alarm(1,3000,0,startup)
