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
print "dhcp server running"
dofile("servers.lc")
dofile("nmea.lc")

