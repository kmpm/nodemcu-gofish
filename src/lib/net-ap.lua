chipid = node.chipid()

wifi.setmode(wifi.SOFTAP)
cfg={}
cfg.ssid="GoFish_" .. chipid
cfg.pwd="password"
wifi.ap.config(cfg)

print('SSID:' .. cfg.ssid)
print('Password:' .. cfg.pwd)

cfg={}
cfg.ip="192.168.73.1"
cfg.netmask="255.255.255.0"
cfg.gateway="192.168.73.1"
wifi.ap.setip(cfg)

ip = wifi.ap.getip()

print('Address:' .. ip)

dhcp_config = {}
dhcp_config.start = "192.168.73.129"
wifi.ap.dhcp.config(dhcp_config)
local status = wifi.ap.dhcp.start()
print('dhcp start:' .. dhcp_config.start)
print('dhcp started:' .. tostring(status))
